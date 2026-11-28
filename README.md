# Auto Cuan — AI Autonomous Inventory & Clearance Engine (Tim A26-CS207)

Sistem manajemen inventaris cerdas berbasis AI untuk membantu **Toko Arif Bulak** mencegah kehabisan stok barang cepat laku (*fast-moving*) serta mempercepat perputaran modal dari barang mengendap (*dead-stock*) melalui paket promosi 1-harga.

## Anggota Tim & Pembagian Peran
* **Riyan Rachman** — Next-Gen AI Engineer (Smart Stock-Up & RAG)
* **Fathoni Adam Ilyasa** — Next-Gen AI Engineer (Bundle-Clear & Gen AI Guardrail)
* **Dina Andriani** — Front-End Web Developer (React + Vite + Tailwind CSS)
* **Raihan Daffa Alif** — Back-End Web Developer (Express.js + PostgreSQL + API Gateway)
* **Raihan Dika Pratama** — Data Scientist (Synthetic Data & Feature Engineering)
* **Ayesha Nashanaira** — Data Scientist (Analytical Metrics & Streamlit Dashboard)

## Struktur Repositori
* `frontend/` — Aplikasi web responsif (POS Kasir, Modul Gudang, Dashboard Owner, AI Copilot)
* `backend-express/` — Core REST API (`/api/v1`), validasi Joi, transaksi stok atomik, & gateway AI
* `ai-service/` — Layanan Python FastAPI untuk model ML & Gen AI Copilot
* `data-science/` — Skrip generator dataset sintetis, preprocessing, & dasbor Streamlit
* `docs/` — Dokumentasi teknis dan Kontrak API (`API_CONTRACT.md`)

## 1. Permasalahan Bisnis yang Diselesaikan Model
1. **Smart Stock-Up (Predictive Restock):** Memprediksi tanggal kritis kehabisan stok (*stockout*) dalam 7 hari ke depan pada produk *fast-moving* dan merekomendasikan kuantitas belanja ulang (*restock*).
2. **Bundle-Clear (Automated 1-Price Bundling):** Memasangkan produk *fast-moving* dengan produk *dead-stock* menjadi paket bundel 1-harga dengan optimasi margin keuntungan positif.
3. **AI Warung Copilot:** Asisten berbasis Intent Classification, RAG, dan Gen AI untuk tanya-jawab stok operasional dan pembuatan draf pesan promosi WhatsApp.

## 2. Sumber Dataset, API, dan Library
* **Dataset:** Dataset sintetis `DUMMY_Toko_Arif_Bulak.csv` (maksimal 10.000 baris) yang dimodelkan dari pola transaksi warung agen Toko Arif Bulak *(berlabel DUMMY eksplisit)*.
* **API Eksternal:** Gemini API / OpenAI API[cite: 1].
* **Tech Stack & Library Utama:** Node.js, Express.js, Joi, PostgreSQL (Neon), React, Vite, Tailwind CSS, Python, FastAPI, XGBoost, Prophet, `mlxtend` (FP-Growth), Streamlit.

## 3. Keseimbangan Data & Feature Engineering
*(Diisi oleh tim Data Science pada Hari 3–7: analisis distribusi kelas fast-moving vs dead-stock, time-based train/test split anti-leakage, serta rekayasa fitur sales velocity, turnover rate, dan seasonality weight)*.

## 4. Tabel Perbandingan Model (Evaluasi Baseline)
### A. Smart Stock-Up (Forecasting Stok)
| Model / Konfigurasi | MAE | RMSE | Catatan / Alasan Pemilihan |
| :--- | :--- | :--- | :--- |
| Baseline 1: Prophet | - | - | *(Diisi tim AI Minggu 1 Hari 5–7)* |
| Baseline 2: XGBoost | - | - | *(Diisi tim AI Minggu 1 Hari 5–7)* |

### B. Bundle-Clear (FP-Growth + Linear Programming)
| Konfigurasi Parameter (`min_support` / Bobot Margin) | Jumlah Paket Valid | Rata-rata Margin | Catatan |
| :--- | :--- | :--- | :--- |
| Konfigurasi 1 | - | - | *(Diisi tim AI Minggu 1 Hari 5–7)* |
| Konfigurasi 2 | - | - | *(Diisi tim AI Minggu 1 Hari 5–7)* |

## 5. Bukti Uji 10 Pertanyaan di Luar Konteks (Guardrail Test)
*(Diisi pada Minggu 4 QA-06 untuk mendokumentasikan respons penolakan sopan AI Warung Copilot terhadap 10 pertanyaan di luar topik operasional warung)*.
