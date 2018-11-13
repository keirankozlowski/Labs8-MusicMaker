const admin = require('firebase-admin');
const express = require('express');
const fs = require('fs');

// Firebase-specific dependencies
const firebase = require('firebase');

const config = {
    apiKey: "AIzaSyCls0XUsqzG0RneHcQfwtmfvoOqHWojHVM",
    authDomain: "musicmaker-4b2e8.firebaseapp.com",
    databaseURL: "https://musicmaker-4b2e8.firebaseio.com",
    projectId: "musicmaker-4b2e8",
    storageBucket: "musicmaker-4b2e8.appspot.com",
    messagingSenderId: "849993185408"
};

const Firestore = require('@google-cloud/firestore');
const firestore = new Firestore({
  projectId: "musicmaker-4b2e8",
});
firebase.initializeApp(config);
const db = firebase.firestore();
const settings = {timestampsInSnapshots: true};
firestore.settings(settings);

const storage = require('@google-cloud/storage')({
  projectId: 'musicmaker-4b2e8'
});

///////////////////////

const app = express();
// test GET request, adding key/value pair to Firebase

app.get('/teachers', async (req, res, next) => {
  try {
    const teachersRef = await db.collection('teachers').get();
    const teachers = [];
    teachersRef.forEach((doc) => {
      teachers.push({
        id: doc.id,
        data: doc.data
      });
    });
    res.json(teachers);
  } catch(err) {
    next(err);
  }
});

// GET a list of all students studying under a specific teacher

app.get('/teachers/:id', async (req, res, next) => {
  try {
    const id = req.params.id;
    // if(!id) throw new Error('Please provide a teacher ID.');
    const studentsRef = await db.collection('teachers').doc(id).collection('students').get();
    const students = [];
    studentsRef.forEach((doc) => {
      students.push({
        id: doc.id,
        data: doc.data
      });
    });
    res.json(students);
  } catch (err) {
    next (err);
  }
});


// GET a list of all assignments listed under a specific teacher
// can consider changing this to a more high-level 'assignments' endpoint

app.get('/teachers/:id/assignments', async (req, res, next) => {
  try {
    const id = req.params.id;
    // if(!id) throw new Error('Please provide a teacher ID.');
    const assignmentsRef = await db.collection('teachers').doc(id).collection('assignments').get();
    const assignments = [];
    assignmentsRef.forEach((doc) => {
      assignments.push({
        id: doc.id,
        data: doc.data
      });
    });
    res.json(assignments);
  } catch(err) {
    next(err);
  }
});

// GET a list of all assignments for a specific student
// I can make this into a teachers -> students type endpoint, but it seems unnecessary for now

app.get('/students/:id/assignments', async (req, res, next) => {
  try {
    const id = req.params.id;
    // if(!id) throw new Error('Please provide a student ID.');
    const assignmentsRef = await db.collection('students').doc(id).collection('assignments').get();
    const assignments = [];
    assignmentsRef.forEach((doc) => {
      assignments.push({
        id: doc.id,
        data: doc.data
      });
    });
    res.json(assignments);
  } catch(err) {
    next(err);
  }
});


// POST

// app.post('/teachers', async (req, res, next) => {
//   try {
//     const { email }  = req.body.email;
//     // if(!name) throw new Error('Name is blank!');
//     const teacherData = { email };
//     const teachersRef = await db.collection('teachers').document('').add(teacherData);
//     res.json({
//       id: teachersRef.id,
//       teacherData
//     });
//   } catch(err) {
//     console.log(err.message);
//     next(err);
//   }
// });

///////////////////////

// PUT

// app.put('/', (req, res) => {
//   console.log('PUT test');
//   res.send('hello!');
// });

///////////////////////

// DELETE

// app.delete('/', (req, res) => {
//   console.log('DELETE test');
//   res.send('hello!');
// });

///////////////////////

//=================================================== STUDENTS =================================================================
function parseDate(date){
  const month = date.getMonth() + 1;
  const day = date.getDate() + 1;
  const year = date.getFullYear();
  const hour = date.getHours() > 12 ? date.getHours() - 12 : date.getHours();
  const minute = date.getMinutes() == '0' ? '00' : date.getMinutes();
  const amPm = date.getHours() >= 12 ? "PM" : "AM";
  const reformattedDueDate = month + "/" + day + "/" + year + " at " + hour + ":" + minute + " " + amPm
  return reformattedDueDate;
};

// GET list of all of student's assignments, details: assignmentName, dueDate, and status
app.get('/student/assignments/:idStudent', async (req, res, next) => {
  try {
  const studentId = req.params['idStudent'];
  const assignments = {};

  const assignmentsRef =  await db.collection('students').doc(studentId).collection('assignments').orderBy('dueDate', 'desc');
  const allAssignments = await assignmentsRef.get()
  .then(snap => {
    snap.forEach(doc => {
      root = doc.data();
      reformattedDueDate = parseDate(root.dueDate);
      assignments[doc.id] = [root.assignmentName, reformattedDueDate, root.status];
    })
  })

  res.json(assignments);

  } catch(err) {
  next(err);
  }
});


//GET a single assignment from a student, details: assignmentName, dueDate, teacher, instrument, level, piece, instructions, feedback
app.get('/student/:idStudent/assigment/:idAssignment', async (req, res, next) => {
  try {
      const studentId = req.params['idStudent'];
      const assignmentId = req.params['idAssignment'];
      const assignment = {};      

      const assignmentRef =  await db.collection('students').doc(studentId).collection('assignments').doc(assignmentId);
      const getDoc = await assignmentRef.get()
      .then(doc => {
        root = doc.data();
        reformattedDueDate = parseDate(root.dueDate);
        assignment[doc.id] = [root.assignmentName, reformattedDueDate, root.teacher, root.instrument, root.level, root.piece, root.instructions, root.feedback]
      })

      res.json(assignment);

  } catch (err) {
  next (err);
  }
  });


//GET student can get their sheetMusic(pdf)
app.get('/student/:idStudent/assigment/:idAssignment/sheetMusic', async (req, res, next) => {
  try {
      const studentId = req.params['idStudent'];
      const assignmentId = req.params['idAssignment'];
  
      const assignmentRef =  await db.collection('students').doc(studentId).collection('assignments').doc(assignmentId).get();

      const musicSheet = assignmentRef.get("sheetMusic");
      const segments = musicSheet['0']._key.path.segments
      const dirName = segments[segments.length -2];
      const filename = segments[segments.length -1];
      const options = {
          destination : 'temp/' + studentId + '_' + filename,
      };

      const bucket = await storage.bucket('musicmaker-4b2e8.appspot.com');
      await storage.bucket('musicmaker-4b2e8.appspot.com')
                   .file(dirName + '/' + filename)
                   .download(options);

      const displaysFile = await fs.readFile('temp/' + studentId + '_' + filename, (err, data) => {
        res.contentType("application/pdf");
        res.send(data);
      });

  } catch (err) {
  next (err);
  }
  });

//GET student can get their recorded video
app.get('/student/:idStudent/assigment/:idAssignment/video', async (req, res, next) => {
  try {
      const studentId = req.params['idStudent'];
      const assignmentId = req.params['idAssignment'];
  
      const assignmentRef =  await db.collection('students').doc(studentId).collection('assignments').doc(assignmentId).get();

      const video = assignmentRef.get("video");
      // console.log('1**********************************', video)
      const segments = video['0']._key.path.segments;
      // console.log('2**********************************', segments)
      const dirName = segments[segments.length -2];
      const filename = segments[segments.length -1];
      const options = {
          destination : 'temp/' + studentId + '_' + filename,
      };
      const bucket = await storage.bucket('musicmaker-4b2e8.appspot.com');
      await storage.bucket('musicmaker-4b2e8.appspot.com')
                   .file(dirName + '/' + filename)
                   .download(options);

      const displaysVideo = await fs.readFile('temp/' + studentId + '_' + filename, (err, data) => {
        res.contentType("video/mov");
        // console.log('4**********************************', res.contentType("video/mov"));
        // console.log('5**********************************', displaysVideo.pipe(res))
        res.send(data);
        // console.log('6**********************************', res.send(data));

      });
      // console.log('7**********************************', displaysVideo);

  } catch (err) {
  next (err);
  }
  });

  //POST students can create a video
app.get('/student/:idStudent/assigment/:idAssignment/video', async (req, res, next) => {
  try {

  } catch (err) {
  next (err);
  }
  });

// server instantiation

const server = app.listen(8000, function () {

  const host = server.address().address;
  const port = server.address().port;

  console.log(`Server listening on port ${port}.`);
});
