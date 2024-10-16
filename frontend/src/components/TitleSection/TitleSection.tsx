import { useEffect, useState } from 'react';
import { useAuth0 } from '@auth0/auth0-react';
import { Link } from 'react-router-dom';
import apiClient from '../../utils/axios';
import "react-responsive-carousel/lib/styles/carousel.min.css";
import './TitleSection.css'

const TitleSection = () => {
  const [currentQuote, setCurrentQuote] = useState('');
  const [email, setEmail] = useState('');
  const { isAuthenticated, user, loginWithRedirect } = useAuth0();

  const quotes = [
    "Design Beyond Imagination.",
  ];

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    try {
      const response = await apiClient.post('/api/lead', { email });
      console.log(response.data);
      // Redirect to login after submitting the email
      loginWithRedirect();
    } catch (error) {
      if (error instanceof Error) {
        console.error(`Caught error: ${error.message}`);
      }
    }
  };

  const getRandomQuote = () => {
    const randomIndex = Math.floor(Math.random() * quotes.length);
    setCurrentQuote(quotes[randomIndex]);
  };

  useEffect(() => {
    getRandomQuote();
  }, []);

  return (
    <header>
      <div className="intro">
        <h1> Tokenize Real World Entities using the Ethereum Blockchain </h1>
        <h1 style={{ opacity: '0.7' }}>{currentQuote}</h1>
        {isAuthenticated && <h3 style={{ opacity: '0.7' }}>Welcome, {user?.name?.split('@')[0]}</h3>}
        <form onSubmit={handleSubmit}>
          <input
            type="email"
            name="email"
            id="email"
            placeholder="Email Address"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
          <button type="submit">Sign Up</button>
          <Link to="/pricing" className='pricingBtn'>Pricing</Link>
        </form>
      </div>
      <img src="https://stories.freepiklabs.com/storage/49289/Software-integration-01.svg" alt="" />
    </header>
  );
};

export default TitleSection;
