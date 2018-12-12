import React, { Component } from "react";
import axios from "axios";

import { Button, Card, CardBody, CardImg, CardSubtitle, CardText, CardTitle, Form, FormGroup, FormTitle, Input, Label } from 'reactstrap';

const formContainer = { maxWidth: 800, margin: '0 auto 10px', border: "3px solid #A9E8DC" };

class Settings extends Component {
  constructor(props) {
    super(props);
    this.state = {
      email: "",
      name: {
        prefix: "",
        firstName: "",
        lastName: ""
      }
    };
  };

  updateName = event => {
    const teacherId = 'pwUGQC7SHBiPKPdnOq2c';

    axios
      .put(`https://musicmaker-4b2e8.firebaseapp.com/teacher/${teacherId}/settingsEdit`)
      .then(res => {
        console.log(res.data)
        this.setState({
          firstName: res.data.name.firstName,
          lastName: res.data.name.lastName
        })
      })
      .catch(err => console.error('Sorry, an error was encountered while updating your settings.', err));
  }

  handleChange = (e) => {
    this.setState({inputValue: e.target.value});
  }

  handleSubmit(event) {
    alert(`Settings updated successfully! Your name is now ${this.state.firstName} ${this.state.lastName}.`);
    event.preventDefault();
  }

  componentDidMount() {
    const teacherId = 'pwUGQC7SHBiPKPdnOq2c';

      axios
          .get(`https://musicmaker-4b2e8.firebaseapp.com/teacher/${teacherId}/settings`) //match params.id when this becomes fully dynamic
          .then(res => {
              console.log(res.data)
              this.setState({
                  email: res.data.email,
                  prefix: res.data.name.prefix,
                  firstName: res.data.name.firstName,
                  lastName: res.data.name.lastName,
                  subscribed: true
              })
          })
          .catch(err => console.error('Sorry, an error was encountered.', err));
  }

  render() {
    return (
      <div className="container" style = {formContainer}>
        <Card style = {{padding: "20px"}}>
            <CardTitle>Your Information</CardTitle>
            <CardSubtitle>Email: {this.state.email}</CardSubtitle>
            <CardText>Title: {this.state.prefix}</CardText>
            <CardText>First Name: {this.state.firstName}</CardText>
            <CardText>Last Name: {this.state.lastName}</CardText>
        </Card>
        <Form onSubmit = {(e) => this.handleSubmit(e)}>
          <FormGroup>
            <h2>Update Your Information</h2>
              <Label>First Name</Label>
                <Input value = {this.firstName} onChange = {(e) => this.handleChange(e)} type = 'text' />
              <Label>Last Name</Label>
                <Input value = {this.lastName} onChange = {(e) => this.handleChange(e)} type = 'text' />
          </FormGroup>
          <Button type = 'submit' onClick = {this.updateName}>Submit Changes</Button>
        </Form>
      </div>
    );
  }
}

export default Settings;
