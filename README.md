# The Talking Journal

A private AI-assisted journaling web application built with Ruby on Rails.

The Talking Journal combines traditional journaling with conversational AI, allowing users to write personal entries, organize thoughts, and interact with an AI assistant that can help reflect on patterns, summarize ideas, and explore journal content in a more dynamic way.

---

## Features

- User authentication with Devise
- Private journal entries tied to individual user accounts
- Create, edit, and delete journal entries
- Categorize entries (dreams, reflections, freeform writing, etc.)
- AI-powered conversation interface for discussing journal content
- Persistent conversation history with sidebar navigation
- Delete and manage past conversations
- Turbo / Hotwire updates for a smoother real-time chat experience
- Clean Ruby on Rails MVC architecture

---

## Tech Stack

- **Ruby** 3.3.6
- **Ruby on Rails** 8
- **SQLite3** (development)
- **Devise** (authentication)
- **Hotwire / Turbo**
- **OpenAI API**
- **ERB views**
- **RubyMine** (development IDE)

---

## How It Works

Users create private journal entries that are stored securely under their account.

In addition to writing entries, users can access a **Talk With Your Journal** feature, which creates AI-powered conversations that act as a reflective companion. The AI can help summarize ideas, discuss themes, interpret dreams, and explore journal content conversationally.

Conversation threads are stored separately so users can revisit past AI discussions.

---

## Installation

Clone the repo:

```bash
git clone https://github.com/YOUR_USERNAME/the-talking-journal.git
cd the-talking-journal
```

Install dependencies:

```bash
bundle install
```

Set up the database:

```bash
rails db:create
rails db:migrate
```

Create a `.env` file and add your OpenAI API key:

```env
OPENAI_API_KEY=your_api_key_here
```

Start the Rails server:

```bash
bin/rails server
```

Then visit:

```text
http://localhost:3000
```

---

## Future Improvements

- Entry tagging and advanced filtering
- AI summaries across journal history
- Sentiment or pattern analysis
- Improved UI styling with Tailwind
- Export journal entries
- Markdown support

---

## Why I Built This

The Talking Journal started as a way to explore the intersection of:

- journaling
- self-reflection
- AI conversation
- personal knowledge systems

I wanted to build something that felt more interactive than a traditional journal while still maintaining privacy and simplicity.

This project also helped me deepen my understanding of:

- Rails MVC architecture
- authentication and user ownership
- API integration
- Turbo / Hotwire interactions
- building conversational interfaces in a web app

---

## Author

**Cameron Beck**  
Computer Science Graduate | IT / Developer | Building projects that combine technology, creativity, and human-centered design
