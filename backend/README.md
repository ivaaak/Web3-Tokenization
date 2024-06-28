This structure organizes the backend code as follows:

src/: Main source code directory

config/: Configuration files for different services
controllers/: Request handlers for different routes
middleware/: Custom middleware functions
models/: Database models (if using an ORM/ODM)
routes/: API route definitions
services/: Business logic and external service interactions
utils/: Utility functions and helpers
contracts/: Smart contract ABIs and addresses
queue/: Job queue setup and definitions
server.ts: Main application file


tests/: Test files separated into unit and integration tests
scripts/: Utility scripts, like smart contract deployment
Root-level configuration files