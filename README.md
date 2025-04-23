# Archie AI: The EPFL AI Assistant for EA 🚀🤖🏛️

**(EA + AI + API Integration)**

---

**Are you tired of wrestling with EA Repository maintenance?** Do you dream of a magical assistant who knows the EPFL architecture landscape like the back of its digital hand? Wish you could just *ask* who edits an application instead of digging through documentation?

**Well, dream no more! Introducing Archie AI Assistant**

This project is building an intelligent bridge between EPFL's EA instance and the power of [OpenAI](https://openai.com/). Our goal is to create a helpful sidekick that can:

1.  **Answer your questions** about EPFL's architecture stored in the EA repositroy.
2.  **Help you populate and maintain** the the EA repository with less manual toil.

Think of it as your **digital EA sous-chef** 🧑‍🍳, prepping the data so you can focus on the strategic masterpiece!

---

## ✨ What's the Big Idea? ✨

EPFL has a wealth of architectural information in its EA repository, but accessing and updating it can sometimes feel like an archaeological dig. We're leveraging the magic of Large Language Models (LLMs) via the OpenAI API to:

* **Query with Natural Language:** Ask questions like "Which applications rely on service X?" or "Show me the business capabilities supported by application Y."
* **Automate Data Entry:** Help fill in the blanks, like finding application editors, identifying stakeholders, or suggesting relationships between components (starting with the "Find Editors" use case!).
* **Improve Data Quality:** Suggest corrections or inconsistencies based on its understanding.

All integrated smoothly within EPFL's Azure ecosystem and secured with Entra ID.

---

## 🎯 Core Features (Planned & In-Progress) 🎯

* ✅ **Natural Language Querying:** Ask questions about the architecture.
* ✅ **"Find Editors" Assistant:** Intelligently suggest and add application editors to the EA tool (Our MVP!).
* 📝 **Populate Application Details:** Help fill in descriptions, business owners, etc. (Future).
* 🔗 **Suggest Relationships:** Identify potential connections between architectural elements (Future).
* ❓ **Consistency Checks:** Spot potential gaps or outdated information (Future).
* *... Your brilliant ideas here!*

---

## 🏗️ The Blueprint (High-Level Architecture) 🏗️

We're building this using a modern, cloud-native approach on Azure:

1.  **Frontend (UI):** A slick web interface (built with [React/Vue/Angular - TBD]) hosted on Azure Static Web Apps. Users log in via EPFL Entra ID.
2.  **Backend (MCP Server):** The brain of the operation! Serverless Azure Functions written in Python handle:
    * Orchestrating requests.
    * Talking to the OpenAI API (securely, using keys from Azure Key Vault).
    * Interacting with the EA REST API (using delegated user permissions via OIDC/Entra ID).
    * Managing different "Agents" for specific tasks (like the "Editor Finder Agent").
3.  **OpenAI API:** Provides the language understanding and generation capabilities.
4.  **EA API:** The source of truth and the place we update.
5.  **EPFL Entra ID:** Handles secure authentication and authorization.
6.  **GitHub:** Hosts all our beautiful code and runs our CI/CD pipelines (GitHub Actions or Azure DevOps).

**(Psst... a proper architecture diagram should be linked here soon!)**

---

## 🛠️ Tech Stack 🛠️

* **Cloud:** Microsoft Azure (Azure Functions, Static Web Apps, Key Vault, Application Insights)
* **AI:** OpenAI API (GPT-4 or similar)
* **Backend:** Python 🐍, Azure Functions
* **Frontend:** JavaScript/TypeScript (React/Vue/Angular - TBD)
* **Authentication:** EPFL MS Entra ID (OIDC)
* **Architecture Tool:** EPFL EA Tool
* **Code & CI/CD:** GitHub / GitHub Actions / Azure DevOps
* **Maybe some:** `Langchain` or similar frameworks to help manage prompts and context.

---

## 🚀 Getting Started (Development) 🚀

*(High-level - more details to come in CONTRIBUTING.md)*

1.  **Clone the repo:** `git clone [your-repo-url]`
2.  **Set up Azure:** Ensure you have access to the required Azure resources.
3.  **Configure Entra ID:** The application registration details will be needed.
4.  **Python Environment:** Set up your Python environment (`venv` recommended) and install dependencies (`pip install -r requirements.txt`).
5.  **Secrets:** Configure access to Azure Key Vault for API keys (OpenAI primarily).
6.  **Run it!** (Specific instructions will follow for running the Functions locally and the frontend).

---

## 💡 How to Use (Example: Find Editors) 💡

1.  Log in to the A²I³ web interface using your EPFL credentials.
2.  Select an application from the list (pulled from ADOIT).
3.  Click the "Find Editors" button.
4.  A²I³ sends the application details to OpenAI via the MCP Server agent.
5.  OpenAI suggests potential editors based on the info.
6.  The MCP Server agent potentially verifies/creates these editors in ADOIT via its API.
7.  The results are displayed in the UI. Magic! ✨

---

## 🤝 Contributing 🤝

This is an EPFL project! We welcome contributions, ideas, and feedback.

* Got an idea? Found a bug? Open an issue!
* Want to contribute code? Fork the repo, create a branch, and submit a Pull Request.
* Let's make EA at EPFL even better, together! We might even share some Swiss chocolate 🍫 for great contributions 😉.

*(Look for a `CONTRIBUTING.md` file for more detailed guidelines soon).*

---

## 📜 License 📜

MIT License

---

**Happy Architecting!** 🇨🇭