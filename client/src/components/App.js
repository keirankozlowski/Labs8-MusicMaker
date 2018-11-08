import React, { Component } from 'react';
import { Route } from 'react-router-dom';

import * as routes from '../constants/routes';

import Navigation from './Navigation';
import LandingPageView from '../views/landingView';
import SignUpView from '../views/signupView';
import SignInView from '../views/signinView';

import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        <Navigation />

        <Route
          exact path={ routes.LANDING }
          component={ LandingPageView }
        />

        <Route
          exact path={ routes.SIGN_UP }
          component={ SignUpView }
        />

        <Route
          exact path={ routes.SIGN_IN }
          component={ SignInView }
        />
      </div>
    );
  }
}

export default App;