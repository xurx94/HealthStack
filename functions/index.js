const functions = require("firebase-functions");
const { GenerativeModel } = require("@google/generative-ai");

// Reaches into the hidden .env file on the server
const API_KEY = process.env.GEMINI_API_KEY; 

exports.analyzeReport = functions.https.onCall(async (data, context) => {
    try {
        const rawText = data.text || "";
        const base64File = data.fileBytes; 
        const mimeType = data.mimeType || "application/pdf";

        const model = new GenerativeModel({ model: "gemini-3.0-flash", apiKey: API_KEY });

        const promptText = `
          You are an expert medical data extractor. Read this lab report.
          Find the current patient vitals if they exist. 
          Return ONLY a raw JSON object with the exact keys: "bp", "sugar", "hemo", "hr", "weight".
          ${rawText ? '\nRAW TEXT:\n' + rawText : ''}
        `;

        let content;
        if (base64File) {
            content = {
                role: "user",
                parts: [
                    { text: promptText },
                    { inlineData: { mimeType: mimeType, data: base64File } }
                ]
            };
        } else {
            content = { role: "user", parts: [{ text: promptText }] };
        }

        const response = await model.generateContent([content]);
        let jsonString = response.text.replace(/```json/g, '').replace(/```/g, '').trim();
        
        return JSON.parse(jsonString);

    } catch (error) {
        console.error("AI Proxy Error:", error);
        throw new functions.https.HttpsError("internal", "Failed to analyze report.", error);
    }
});