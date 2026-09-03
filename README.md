# **NOVA AI — Fully Offline AI Office Assistant v1.0**

#### **100% FULLY OFFLINE • PRIVATE • LOCAL • AIR-GAPPED AI**

---

**NOVA AI** is a **100% fully offline AI Office Assistant** designed to run entirely on a Windows PC.

Once the **Qwen2.5-7B-Instruct-Q4_K_M.gguf** model is copied into:

```text
C:\NOVA_AI\model\
```

**NOVA AI does not require an Internet connection to operate.**

No cloud AI.
No API subscription.
No external AI service.
No Ollama.
No Node.js.
No Python.
No internet connection required at runtime.

All AI inference takes place locally on the user's own computer.

---

## #### ⭐ WHAT MAKES NOVA AI DIFFERENT?

NOVA AI is designed around two important principles that are often missing from local/offline AI assistants.

### **1. Persistent Conversation Memory**

NOVA AI remembers your previous conversations through browser-based local storage.

```text
Your Chat
   ↓
Browser Local Storage
   ↓
Previous Messages
   ↓
Future Conversations
```

The stored conversation history remains available when the application is reopened.

The user can also:

* Continue previous conversations
* Use previous messages as context
* Clear the complete chat history with one click
* Export the complete conversation
* Delete the stored memory whenever required

NOVA AI stores up to **150 messages** in browser localStorage and sends the latest **18 messages** as conversational context for follow-up questions.

### **2. Controlled Responses — No Random Essays**

NOVA AI is specifically designed not to produce unnecessarily long, irrelevant answers to simple inputs.

For example:

```text
User:
Hi

NOVA AI:
Hi! How can I help you?
```

Instead of producing several paragraphs of unrelated information.

The system includes:

* Greeting detection
* Strict system prompting
* Low temperature configuration
* Response-length controls
* Full / In Short / Ultra modes
* Anti-hallucination instructions

For uncertain information, the model is instructed to say:

```text
I am not sure.
```

rather than inventing an answer.

---

# #### 🚀 CORE CONCEPT

NOVA AI combines:

```text
LOCAL AI MODEL
       +
LOCAL AI ENGINE
       +
LOCAL WEB INTERFACE
       +
LOCAL CHAT MEMORY
       +
OFFICE PRODUCTIVITY TOOLS
       =
NOVA AI
```

The entire system operates on the local Windows machine.

---

# #### 🔒 100% OFFLINE & AIR-GAPPED OPERATION

NOVA AI is designed for environments where Internet connectivity is unavailable or undesirable.

After the required files and model have been placed on the computer:

```text
Internet
   X
   |
   X
NOVA AI
   |
   +---- Local llama-server
   |
   +---- Local Qwen Model
   |
   +---- Local Browser
```

There is no requirement for cloud inference.

### **Offline model location**

```text
C:\NOVA_AI\model\Qwen2.5-7B-Instruct-Q4_K_M.gguf
```

If this model file is present, the local AI engine can load it into RAM.

---

# #### 🧠 AI MODEL

### **Qwen2.5-7B-Instruct**

| Specification                | Details                   |
| ---------------------------- | ------------------------- |
| Model                        | Qwen2.5-7B-Instruct       |
| Quantization                 | Q4_K_M                    |
| Format                       | GGUF                      |
| Parameters                   | 7.62 billion              |
| Model Size                   | Approximately 4.36 GB     |
| Context Window               | 4,096 tokens              |
| Primary Language             | English                   |
| Translation                  | Hindi ↔ English supported |
| Runtime                      | Local CPU inference       |
| AI Engine                    | llama.cpp                 |
| Internet Required at Runtime | **No**                    |

The Q4_K_M quantization provides a practical balance between model quality, RAM requirements and CPU inference speed.

---

# #### 🏗️ SYSTEM ARCHITECTURE

```text
                    USER
                     │
                     ▼
              ┌──────────────┐
              │  index.html  │
              │  Frontend UI │
              └──────┬───────┘
                     │
                     │ HTTP POST
                     ▼
              127.0.0.1:8080
                     │
                     ▼
          ┌─────────────────────┐
          │  llama-server.exe   │
          │     llama.cpp       │
          └──────────┬──────────┘
                     │
                     ▼
       Qwen2.5-7B-Instruct-Q4_K_M
                     │
                     ▼
              Local Inference
                     │
                     ▼
             SSE Token Stream
                     │
                     ▼
              NOVA AI Frontend
```

### **Frontend → Backend**

The browser communicates with the locally running AI server through:

```text
http://127.0.0.1:8080
```

The frontend sends requests to:

```text
/v1/chat/completions
```

The response is streamed back using:

```text
Server-Sent Events (SSE)
```

This allows the response to appear progressively rather than waiting for the entire generation to finish.

---

# #### 📁 PROJECT STRUCTURE

```text
C:\NOVA_AI\

│
├── 0_DIAGNOSE_FIRST.bat
├── 1_CHECK.bat
├── 2_SETUP.bat
├── 3_START.bat
├── 4_STOP.bat
├── 5_FIX.bat
├── 6_DIAGNOSE.bat
│
├── engine\
│   ├── llama-server.exe
│   ├── llama.dll
│   ├── ggml.dll
│   └── other required DLL files
│
├── model\
│   └── Qwen2.5-7B-Instruct-Q4_K_M.gguf
│
├── frontend\
│   └── index.html
│
├── logs\
│   └── nova_start.txt
│
└── chat_history\
```

The project is designed around a single master folder:

```text
C:\NOVA_AI\
```

This makes the system easier to copy, back up and transfer between compatible Windows computers.

---

# #### ▶️ HOW TO START NOVA AI

### **STEP 1 — Place the model**

Copy:

```text
Qwen2.5-7B-Instruct-Q4_K_M.gguf
```

into:

```text
C:\NOVA_AI\model\
```

The final path should be:

```text
C:\NOVA_AI\model\Qwen2.5-7B-Instruct-Q4_K_M.gguf
```

### **STEP 2 — Run the diagnostic**

Double-click:

```text
0_DIAGNOSE_FIRST.bat
```

This checks the installation and creates diagnostic information.

### **STEP 3 — Check the installation**

Run:

```text
1_CHECK.bat
```

### **STEP 4 — Start NOVA AI**

Double-click:

```text
3_START.bat
```

The launcher starts the local AI engine and opens the NOVA AI interface.

### **STEP 5 — Use NOVA AI**

The browser opens the local interface.

The local server runs on:

```text
127.0.0.1:8080
```

---

# #### 🟢 STATUS MONITORING

NOVA AI includes a visual server/model status indicator.

| Status    | Meaning                  |
| --------- | ------------------------ |
| 🟢 Green  | Model loaded and ready   |
| 🟡 Yellow | Model loading into RAM   |
| 🔴 Red    | Local server unavailable |

The first model load can take approximately **60–90 seconds**, depending on the computer.

NOVA AI also checks the local server periodically.

If the server crashes, the launcher can attempt automatic recovery.

---

# #### 💬 CHAT FEATURES

### **Persistent Chat History**

NOVA AI stores recent conversation history locally.

Features include:

* Up to 150 stored messages
* Browser localStorage
* History restored after reload
* Last 18 messages supplied as conversational context
* Follow-up questions supported
* One-click Clear History
* Full chat export
* Local-only storage

### **Greeting Detection**

Simple greetings receive concise responses.

Examples:

```text
Hi
Hello
Good morning
Good afternoon
Good evening
Thank you
```

NOVA AI avoids unnecessarily generating a long essay for these inputs.

---

# #### 🛡️ ANTI-HALLUCINATION DESIGN

NOVA AI uses multiple controls intended to reduce irrelevant or invented responses.

### **Low Temperature**

```text
Temperature: 0.1
```

### **Strict System Prompt**

The model is instructed to:

* Stay relevant to the user's request
* Avoid inventing facts
* Avoid unnecessary expansion
* Keep simple questions simple
* Acknowledge uncertainty
* Say "I am not sure" when appropriate

This is especially important for an offline AI because there is no automatic cloud-based fact-checking layer.

---

# #### 🎤 SPEECH TO TEXT

NOVA AI includes a microphone button beside the message input.

### **Workflow**

```text
Click MIC
   ↓
Speak
   ↓
Speech recognition
   ↓
Text appears in input box
   ↓
Send to NOVA AI
```

The configured language is:

```text
en-IN
```

for Indian English.

The implementation uses browser speech-recognition capabilities.

---

# #### 📊 30-CHART BUILDER

NOVA AI includes a built-in chart creation system.

Click:

```text
Add Chart
```

after an AI response.

### **21 × 2D Charts**

1. Vertical Bar
2. Horizontal Bar
3. Stacked Bar
4. Clustered Bar
5. Pie
6. Donut
7. Line
8. Area
9. Stacked Area
10. Scatter
11. 2D Bubble
12. Histogram
13. Box & Whisker
14. Radar / Spider
15. Waterfall
16. Treemap
17. Funnel
18. Gantt
19. Heatmap
20. Sankey
21. Choropleth

### **9 × 3D Charts**

1. 3D Bar
2. 3D Pie
3. 3D Ribbon
4. 3D Scatter
5. 3D Surface
6. 3D Wireframe
7. 3D Waterfall
8. 3D Bubble
9. 3D Globe

### **Chart Workflow**

```text
Add Chart
    ↓
Select Chart Type
    ↓
Enter Labels + Values
    ↓
Generate
    ↓
Preview
    ↓
Insert into Chat
```

Charts can be embedded directly into the conversation.

---

# #### 📉 RESPONSE CONDENSING

NOVA AI provides four response-condensing options:

```text
75%
50%
30%
15%
```

### **75%**

Light trimming while retaining most information.

### **50%**

Approximately half-length version.

### **30%**

Brief version containing the important information.

### **15%**

Ultra-concise summary.

These controls can be applied to generated responses such as:

* Letters
* Reports
* Summaries
* Notes
* Explanations
* General text

---

# #### 📄 PDF & IMAGE EXPORT

NOVA AI can export generated content.

Click:

```text
Export
```

before exporting, users can configure:

### **Font**

* Times New Roman
* Arial
* Calibri
* Georgia
* Courier New

### **Font Size**

```text
10–16 pt
```

### **Colour**

* Black
* Navy Blue
* Dark Green
* Dark Red
* Charcoal

### **Formatting**

* Bold
* Single line spacing
* 1.5 spacing
* Double spacing

### **Export Formats**

```text
NOVA-AI-Export.pdf
NOVA-AI-Export.png
```

The PDF export uses jsPDF and image export uses html2canvas.

---

# #### 📝 RESPONSE LENGTH CONTROL

NOVA AI provides three response modes.

| Mode         | Behaviour                    |
| ------------ | ---------------------------- |
| **Full**     | Complete structured response |
| **In Short** | Concise bullet points        |
| **Ultra**    | Maximum 2 sentences          |

The Full mode also handles structured professional tasks appropriately.

For example, when Full mode is selected:

* Letters
* D.O. Letters
* Reports
* Minutes of Meeting

are generated with sufficient structure and length rather than being unnecessarily compressed.

---

# #### 🏢 11 PROFESSIONAL TASK MODES

### **1. Chat**

General question and answer.

### **2. Grammar Check**

Corrects:

* Grammar
* Spelling
* Punctuation

### **3. Draft Letter**

Creates a formal service letter containing:

```text
Date
Reference
Subject
Salutation
Body
Closing
Designation
```

### **4. D.O. Letter**

Creates a Demi-Official letter using:

```text
First person
Dear [Name]
Personal but official tone
```

### **5. File Noting**

Creates structured file notes containing:

```text
Subject
Background
Present Position
Proposal
Orders Requested
```

### **6. Summarise**

Condenses supplied material to approximately 20% length with:

```text
Key Points
Decisions
Conclusion
```

### **7. Report**

Creates formal reports using:

```text
Introduction
Background
Findings
Issues
Recommendations
Conclusion
```

### **8. Minutes (MoM)**

Converts meeting notes into formal Minutes of Meeting with Action Items.

### **9. Translate**

Supports:

```text
Hindi ↔ English
```

with an official/professional tone.

### **10. Compare / Analyse**

Produces:

```text
Side-by-side comparison
Pros
Cons
Recommendation
```

### **11. Additional General Chat / Office Workflows**

The local AI can also be used for general drafting, rewriting, summarisation, analysis and professional assistance.

---

# #### 📚 DICTIONARY PANEL

NOVA AI includes a built-in English dictionary panel.

It contains **40 official English words** with:

* Word
* Part of speech
* Definition
* Example sentence

Examples include:

```text
pursuant
perusal
enclosure
supersede
forthwith
concurrence
rescind
cognizance
adjudicate
incumbent
```

The dictionary has live filtering.

Type letters into the search field to immediately filter the available words.

---

# #### ⛔ STOP GENERATION

If an AI response is taking too long or the user no longer wants the response:

```text
STOP
```

can be used to cancel the current generation.

This prevents the user from having to wait for the complete response.

---

# #### 🧠 MEMORY MANAGEMENT

NOVA AI gives the user control over stored conversation data.

### **Stored locally**

```text
Browser
   ↓
localStorage
```

### **Clear Memory**

Use:

```text
Clear History
```

to remove the stored conversation history.

### **Export Memory**

The complete chat can also be exported as a plain text file.

---

# #### 🔄 AUTOMATIC RECOVERY

NOVA AI includes automatic server monitoring.

The startup process checks whether the local server is responding.

If the server stops unexpectedly:

```text
Server Failure
      ↓
Health Checks
      ↓
Failure Detected
      ↓
Restart Attempt
```

The system can attempt to restart the local AI server after repeated failed checks.

---

# #### 🛠️ WINDOWS MANAGEMENT TOOLS

The project includes dedicated BAT utilities.

| File                   | Purpose                                  |
| ---------------------- | ---------------------------------------- |
| `0_DIAGNOSE_FIRST.bat` | Initial full diagnostic                  |
| `1_CHECK.bat`          | Installation and CPU compatibility check |
| `2_SETUP.bat`          | Setup instructions/resources             |
| `3_START.bat`          | Start NOVA AI                            |
| `4_STOP.bat`           | Stop local AI server                     |
| `5_FIX.bat`            | Repair common problems                   |
| `6_DIAGNOSE.bat`       | Detailed diagnostics                     |

---

# #### 💻 TECHNOLOGY STACK

| Layer        | Technology                        |
| ------------ | --------------------------------- |
| AI Model     | Qwen2.5-7B-Instruct               |
| Model Format | GGUF                              |
| Quantization | Q4_K_M                            |
| AI Runtime   | llama.cpp                         |
| Backend      | llama-server.exe                  |
| Frontend     | HTML5 + CSS3 + Vanilla JavaScript |
| API          | OpenAI-compatible API             |
| Streaming    | Server-Sent Events                |
| Storage      | Browser localStorage              |
| Automation   | Windows Batch                     |
| PDF          | jsPDF                             |
| Image Export | html2canvas                       |
| Server Port  | 8080                              |

---

# #### 🚫 WHAT NOVA AI DOES NOT REQUIRE

NOVA AI does **not** require:

```text
❌ Cloud AI
❌ OpenAI API
❌ API keys
❌ Ollama
❌ Python
❌ Node.js
❌ npm
❌ Docker
❌ Remote database
❌ Internet connection at runtime
```

The core AI inference is performed locally through the bundled llama.cpp engine and local GGUF model.

---

# #### 🔐 PRIVACY

NOVA AI is designed for privacy-sensitive local use.

The intended architecture is:

```text
USER DATA
   ↓
LOCAL COMPUTER
   ↓
LOCAL BROWSER
   ↓
LOCAL AI ENGINE
   ↓
LOCAL MODEL
```

The conversation is not sent to a cloud AI service by the local inference architecture.

This makes NOVA AI suitable for environments where keeping working material on the local machine is important.

---

# #### 🎯 INTENDED USE

NOVA AI is designed as a local professional productivity assistant for tasks such as:

* Office drafting
* Letter writing
* D.O. letters
* File noting
* Reports
* Minutes of Meeting
* Summarisation
* Translation
* Grammar correction
* Comparison
* Analysis
* General Q&A
* Dictionary/reference work
* Speech-to-text
* Chart generation
* PDF/image document export

---

# #### ⚠️ IMPORTANT MODEL LIMITATION

NOVA AI is a **local language model**, not a guaranteed factual database.

Even with a low temperature and strict prompting, AI-generated information can still contain errors.

For important:

* Legal
* Medical
* Financial
* Government
* Defence
* Operational
* Safety-critical

decisions, independently verify important facts and use authoritative sources where available.

The offline architecture provides privacy and independence from the Internet; it does **not** guarantee that every generated answer is factually correct.

---

# #### 🚀 QUICK START

```text
1. Extract C:\NOVA_AI\

2. Copy:
   Qwen2.5-7B-Instruct-Q4_K_M.gguf

3. Place it inside:
   C:\NOVA_AI\model\

4. Run:
   0_DIAGNOSE_FIRST.bat

5. Run:
   1_CHECK.bat

6. Run:
   3_START.bat

7. Wait for the model to load.

8. Open/use the NOVA AI interface.

9. Work completely offline.
```

---

# #### 📌 REQUIREMENT

The main requirement for the offline AI engine is the local model:

```text
Qwen2.5-7B-Instruct-Q4_K_M.gguf
```

located at:

```text
C:\NOVA_AI\model\
```

The model requires several GB of RAM to operate, and performance depends heavily on the computer's CPU, available memory and storage speed.

---

# #### 🌐 OFFLINE TRANSFER

One of the major advantages of the architecture is that the complete NOVA AI folder can be transferred to another compatible Windows computer.

Example:

```text
Internet PC
     ↓
Prepare NOVA_AI
     ↓
Copy complete folder
     ↓
USB / DVD / External Drive
     ↓
Offline Windows PC
     ↓
Run 3_START.bat
     ↓
NOVA AI
```

Once the required runtime files and model are present, NOVA AI is designed to operate without Internet access.

---

# #### 🏆 NOVA AI v1.0 HIGHLIGHTS

```text
✓ 100% fully offline AI
✓ Air-gapped capable
✓ Local Qwen2.5-7B model
✓ Persistent local chat memory
✓ 150-message history
✓ 18-message conversational context
✓ Greeting detection
✓ Anti-hallucination prompting
✓ Temperature 0.1
✓ Full / In Short / Ultra modes
✓ 11 professional task modes
✓ Hindi ↔ English translation
✓ Speech-to-text
✓ 30 chart types
✓ 21 2D charts
✓ 9 3D charts
✓ PDF export
✓ PNG image export
✓ Dictionary panel
✓ Stop generation
✓ Server health monitoring
✓ Automatic restart
✓ Diagnostic BAT tools
✓ Repair BAT tool
✓ Local llama.cpp inference
✓ No cloud dependency
✓ No API key required
```

---

# #### 🧩 DESIGN PHILOSOPHY

NOVA AI is built around four principles:

### **PRIVACY**

Keep sensitive work local.

### **OFFLINE**

Remain useful without Internet connectivity.

### **RELEVANCE**

Answer the question that was actually asked.

### **CONTROL**

Give the user control over memory, response length, exports and generation.

---

# #### 📜 PROJECT

**Project:** NOVA AI
**Version:** 1.0
**Platform:** Windows
**Architecture:** Local / Offline / Air-Gapped
**AI Engine:** llama.cpp
**Model:** Qwen2.5-7B-Instruct-Q4_K_M
**Port:** 8080
**Frontend:** HTML5 + CSS3 + JavaScript

---

# #### 👤 BY ARYAN

**NOVA AI — Local Intelligence. Private by Design.**

A fully offline AI assistant designed to bring modern AI-powered office productivity to environments where Internet connectivity, cloud dependence and external data transmission are not desirable.
