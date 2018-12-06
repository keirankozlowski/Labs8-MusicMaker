import React from "react";
import { Navbar, NavbarBrand, NavLink, Nav } from "reactstrap";

import * as routes from "../constants/routes";

import AuthUserContext from "./AuthUserContext";
import SignOutButton from "../components/SignOutButton";

import homeIcon from "../less/imgs/homeIcon.png";

const Navigation = () => (
  <AuthUserContext.Consumer>
    {authUser => (authUser ? <NavigationAuth /> : <NavigationNonAuth />)}
  </AuthUserContext.Consumer>
);

const NavigationAuth = () => (
  <Navbar>
    <NavbarBrand href={routes.DASHBOARD}>
      <img src={homeIcon} />
    </NavbarBrand>
    <SignOutButton />
  </Navbar>
);

const NavigationNonAuth = () => (
  <Navbar>
    <NavbarBrand href={routes.LANDING}>
      <img src={homeIcon} />
    </NavbarBrand>
    <Nav>
      <NavLink href={routes.SIGN_UP}>Sign Up</NavLink>
      <NavLink href={routes.SIGN_IN}>Sign In</NavLink>
    </Nav>
  </Navbar>
);

export default Navigation;
