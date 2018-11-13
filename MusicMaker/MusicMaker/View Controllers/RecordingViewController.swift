//
//  RecordingViewController.swift
//  MusicMaker
//
//  Created by Linh Bouniol on 11/8/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import UIKit
import PDFKit
import AVFoundation

class RecordingViewController: UIViewController {
    
    // MARK: - Properties
    
    var pdfDocument: PDFDocument? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var captureSession: AVCaptureSession!
    private var recordOutput: AVCaptureMovieFileOutput!
    private var lastRecordedURL: URL?

    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cameraPreviewView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func toggleRecord(_ sender: Any) {
        if recordOutput.isRecording {
            recordOutput.stopRecording()
        } else {
            recordOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test
        pdfDocument = PDFDocument(url: Bundle.main.url(forResource: "SamplePDF", withExtension: "pdf")!)
        
        setupCapture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    // MARK: - Methods
    
    private func setupCapture() {
        let captureSession = AVCaptureSession()
        let device = bestCamera()
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device), captureSession.canAddInput(videoDeviceInput) else { fatalError() }
        
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput() // creates a movie file
        guard captureSession.canAddOutput(fileOutput) else { fatalError() } // make sure we can add it to captureSession
        captureSession.addOutput(fileOutput)
        recordOutput = fileOutput
        
        captureSession.sessionPreset = .hd1920x1080 // easier to filter with core image and process
        captureSession.commitConfiguration() // save all this stuff and actually set it up
        
        self.captureSession = captureSession    // starts off not running, so need to start it in viewWillAppear()
        cameraPreviewView.videoPreviewLayer.session = captureSession  // display the capture
    }
    
    private func bestCamera() -> AVCaptureDevice { // might need to change for ipad?
        // can allow user to choose different types of camera: dual, front, back
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            return device
        } else {
            fatalError("Missing expected front camera device")
        }
    }

    // Want to save record url directly to core data, for now this is for testing
    // save the recording as a uuid in core data, but gives back url so we can store the recording
    
    // setup the directory to return a url so we can use it to store the recording
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        let recordingButtonImageName = recordOutput.isRecording ? "Stop" : "Record"
        recordButton.setImage(UIImage(named: recordingButtonImageName)!, for: .normal)
    }
}

extension RecordingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pdfDocument?.pageCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicSheetPageCell", for: indexPath) as! MusicSheetPageCollectionViewCell
        
        cell.pdfView.document = pdfDocument!
        
        if let pdfPage = pdfDocument?.page(at: indexPath.item) {
            cell.pdfView.go(to: pdfPage)
        }
        
        return cell
    }
}

extension RecordingViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.updateViews()
            
            self.lastRecordedURL = outputFileURL
        }
    }
}
