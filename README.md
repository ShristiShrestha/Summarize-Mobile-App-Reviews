# Automated Summarization of Mobile App Reviews using Chain of Density

[PDF Link](https://link.springer.com/content/pdf/10.1007/s10515-025-00533-5.pdf)

### Premise
The explosive growth of mobile app stores has led to "information overload." Popular apps receive thousands of reviews daily. Users cannot read them all to make informed decisions, and existing star-rating systems fail to capture specific user needs. For example, stock trading app users expect seamless transaction executions, transparent pricing, no hidden fees, and strategy resources for maximizing their returns on investments (ROI).  Users navigating current app review systems are forced to navigate a diverse array of feedback, including bug reports, personal user experiences, new feature requests, and suggestions for modifications to existing functionalities. This cognitive burden on new users can significantly diminish their interest in the app, potentially leading to early churn.

### Proposal
In this paper, we propose an LLM-based, automated app review summarization technique focusing on user goals and experiences. The primary goal of generated summaries is to aid users in their app selection processes. 

### Research Gap
Current solutions primarily use extractive summarization techniques (like Hybrid TF-IDF, SumBasic, or LexRank), topic modeling (LDA), or data-intensive abstractive summarization techniques (e.g, neural Seq2Seq, pointer-generator networks). However, they have several limitations:
- **Lack of Coherence**: Extractive summaries and LDA topics are unstructred, disjointed, and unnatural to read. Existing abstractive summaries struggle with informal, syntactically incorrect, and semantically restricted texts, that are often found in app reviews.
- **Target Audience Mismatch**: Existing methods are designed for app developers, not end-user consumption.
- **Sparsity**: Probabilistic and frequency-based techniques miss "sparse" but critical themes as they are dependent on word-repetition. For example, app reviews focusing on "security" are rare instances and highly domain-specific.


### Proposal Architecture
Inspired from Adams et al.'s work, we developed a modified Chain of Density (CoD) prompting strategy to summarize app reviews. Our entire summarization pipeline follows a commonly used "extract-then-abstract" formula. In particular, we generate a summary for a set of reviews as follows:
1. **Extract a manageable, initial summary** using a hybrid TF.IDF technique. The goal is to minimize noise and incorporate important themes of the reviews into the summary.  
2. **Use an LLM to rephrase the initial summary**. The model is instructed to iteratively generate a fixed length summary by progressively "fusing" missing entities into the text without increasing the word count.

We engineered the prompt to specifically define "entities" as functional/non-functional app features, ensuring the LLM focuses on utility for the user rather than generic sentiment. The modified prompt is refered as "CoDr" throughout the paper. 

### Empirical Evaluation & Key Findings
- **Dataset**: We analyzed reviews from eight major apps (e.g., Uber, Tinder, Robinhood, Calm) across four domains.
- **Baseline**: We compare the performance of CoDr prompting with a vanilla prompting strategy (persona-driven, simple instruction) and a widely popular extractive summarization method ("Hybrid TF.IDF").
- **LLM for summarization**: We used GPT-4 (the latest version at the time) to generate summaries using the vanilla, the original CoD, and the CoDr prompts. 
- **Measurements**: We quantified the quality of each summary based on two metrics: the number of unique entities, entity density, and entity recall. We gathered readability measurements in two ways: human evaluation and an LLM-as-evaluator.
- **Quantitative Findings**: The CoDr prompt significantly outperformed standard Vanilla prompts and TF-IDF baselines. It achieved higher entity density (information richness) and higher recall (capturing ~81% of key themes vs. 64% for vanilla prompts).
- **Qualitative Results**: A user study with 48 participants confirmed that even as the summaries became more dense with information, they remained highly readable and natural to humans.
- **Comparative Analysis**: Compared GPT-4 with Gemini Flash 1.5 and Llama-3.1 models. GPT-4 produced the best quality, in terms of entity density and readability. OpenAI's API service to the GPT-4 model was the fastest in execution (2.2 seconds per summary) compared to the Gemini (2.9 seconds) and the Llama (3.9 seconds) models. However, the GPT-4 model incurred the highest cost ($0.102 per summary) in comparison with the Gemini and the Llama models.

### Limitations
- **Context Window**: Due to token limits, we had to employ extractive techniques like hybrid TF.IDF ranking to select the most relevant 350 reviews before feeding them to the LLM.
- **Data size**: We analyzed eight apps across four application domains. For each app, we collected at most 3k recent reviews (as of 2024) and generated an initial, extractive summary of 350 reviews.

### Future Research Directions
- **Integration**: Conducting Randomized Controlled Trials (RCTs) to test if displaying these summaries in a live app store environment changes user download behavior.
- **Bias Mitigation**: Investigating if these summaries can reduce "anchoring bias" (users relying only on the first review they see).

### Tools, Techs, and Methods
- **LLMs & APIs**: OpenAI GPT-4, Google Gemini-1.5-Flash, Meta Llama-3.1-70B.
- **Prompt Engineering**: Chain of Density (CoD), Zero-shot learning, Parameter tuning (Temperature, Top-p).
- **NLP**: Spacy (language detection), NLTK (stop-word removal), GloVe Embeddings (semantic similarity).
- **Statistical Analysis**: Chi-Square tests for readability correlation, Paired t-tests for density comparison.


   


 




