import React from 'react';
import { Navbar, Container, Nav, NavDropdown } from 'react-bootstrap';
import { Facebook, Twitter, Pinterest, Instagram, HouseFill, Search, PersonFill, Cart } from 'react-bootstrap-icons';
import ReactDOM from 'react-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import './style.css';

const TopMenu = () => (
  <Navbar bg="light" expand="lg">
    <Container>
      <Nav className="topMenuGroup1">
        <Nav.Link><Facebook/></Nav.Link>
        <Nav.Link><Twitter/></Nav.Link>
        <Nav.Link><Pinterest/></Nav.Link>
        <Nav.Link><Instagram/></Nav.Link>
      </Nav>
      <Nav className="topMenuGroup1 justify-content-end">
        <Nav.Link><HouseFill/></Nav.Link>
        <Nav.Link><Search/></Nav.Link>
        <Nav.Link><PersonFill/></Nav.Link>
        <NavDropdown title={<Cart/>}>
          <NavDropdown.item></NavDropdown.item>
          <NavDropdown.ItemText>Your cart is empty</NavDropdown.ItemText>
        </NavDropdown>
      </Nav>
    </Container>
  </Navbar>
);

const IslandSnowLogo = () => (
  <div className="row">
    <div className="col">
      <img src="https://courses.ics.hawaii.edu/ics314s23/morea/ui-frameworks/experience-islandsnow-bootstrap-logo.png" alt="Island Snow Logo" className="img-fluid rounded mx-auto d-block py-1" />
    </div>
  </div>
);

const MiddleMenu = () => (
  <div className="row justify-content-center pt-4">
    <div className="col-2">
      <div className="dropdown">
        <div className="dropdown-toggle"><strong>MEN</strong></div>
      </div>
    </div>
    <div className="col-2">
      <div className="dropdown">
        <div className="dropdown-toggle"><strong>WOMEN</strong></div>
      </div>
    </div>
    <div className="col-2">
      <div className="dropdown">
        <div className="dropdown-toggle"><strong>KIDS</strong></div>
      </div>
    </div>
    <div className="col-2">
      <div className="dropdown">
        <div className="dropdown-toggle"><strong>BRANDS</strong></div>
      </div>
    </div>
    <div className="col-2">
      <strong>SEARCH</strong>
    </div>
  </div>
);


const FullWidthImage = () => (
  <div className="row justify-content-center">
    <img src="https://courses.ics.hawaii.edu/ics314s23/morea/ui-frameworks/experience-islandsnow-bootstrap-main.png" className="img-fluid pt-3" alt="Island Snow Main" />
  </div>
);

const FooterMenu = () => (
  <footer style={{ backgroundColor: '#292929', color: 'white' }}>
    <div className="container py-2">
      <div className="row">

        <div className="col">
          NAVIGATION
          <hr />
          <div>About Us</div>
          <div>Employment</div>
          <div>Videos</div>
        </div>

        <div className="col">
          MAIN MENU
          <hr />
          <div>Men</div>
          <div>Women</div>
          <div>Kids</div>
        </div>

        <div className="col">
          CONNECT
          <hr />
          <div>Sign up for the latest updates</div>
          <input type="text" placeholder="Enter Email Address" />
          <div className="btn btn-dark">Join</div>
        </div>

      </div>
    </div>
  </footer>
);


const IslandSnow = () => (
  <Container fluid>
    <TopMenu/>
    <IslandSnowLogo/>
    <MiddleMenu/>
    <FullWidthImage/>
    <FooterMenu/>
  </Container>
);

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<IslandSnow />);



