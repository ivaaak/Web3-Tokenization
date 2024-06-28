import { Link } from 'react-router-dom';
import { useAuth0 } from '@auth0/auth0-react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faMoon, faSignOutAlt } from '@fortawesome/free-solid-svg-icons';
import { ThemeContext } from './components/ThemeContext';
import { useContext } from 'react';
import UserProfile from './components/UserProfile';
import UnauthorizedPage from './components/UnauthorizedPage';
import './App.css';

function App() {
   const { isAuthenticated, user, loginWithRedirect } = useAuth0();
   const { theme, toggleTheme } = useContext(ThemeContext);

   return (
      <div className={`App ${theme}`}> {/* Theme Class */}
         <Router>
            <main>
               <nav>
                  <Link to="/">
                     <div className='navTitle'><h1 className='title'>Arch</h1><h1 className='title2'>AI</h1></div>
                  </Link>

                  <ul>
                     <li>
                        <Link to="/browse">Collections</Link>
                     </li>
                     <li>
                        <Link to="/generate">Generate</Link>
                     </li>
                     {isAuthenticated ? (<>
                        <li style={{ textAlign: 'center' }}>
                           <Link to="/profile">
                              {user?.name?.split('@')[0]}
                           </Link>
                        </li>
                        <button onClick={() => loginWithRedirect()}>
                           <FontAwesomeIcon icon={faSignOutAlt} />
                        </button>
                     </>
                     ) : (
                        <button onClick={() => loginWithRedirect()}>Log In</button>
                     )}
                     <li>
                        <button onClick={toggleTheme}>
                           <FontAwesomeIcon icon={faMoon} />
                        </button>
                     </li>
                  </ul>
               </nav>
               <Routes>
                  {/* <Route path="/" element={<Features />} /> */}
                  <Route path="/profile" element={<UserProfile />} />
                  {/* <Route path="/sketch" element={isAuthenticated ? <SketchImage /> : <UnauthorizedPage />} /> */}
                  <Route path="*" element={<UnauthorizedPage />} /> {/* Catch-all route for unauthorized access */}
               </Routes>
            </main>
         </Router>
      </div>
   );
}

export default App;
