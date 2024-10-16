import { ObjectId } from 'mongodb';
import { Image } from './image'

interface Prompt {
  text: string;
  type: string; // e.g., "open-ended", "multiple-choice"
}

interface Project {
  _id: ObjectId;
  auth0UserId: string;
  usereId: string;
  title: string;
  description: string;
  images: Image[];
  prompts: Prompt[];
}

export default Project;
