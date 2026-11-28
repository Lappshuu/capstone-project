# Kontrak API — Auto Cuan (Toko Arif Bulak)
**Status:** Draft v1.0 (Untuk Review Tim FE & AI)  
**Base URL Express:** `/api/v1`  
**Base URL FastAPI:** `http://localhost:8000`  

## 1. Format Respons Umum
- **Sukses (200):** `{ "status": "success", "message": "...", "data": {} }`
- **Gagal / Error Validasi (400 / 500):** `{ "status": "fail", "message": "Penjelasan error" }`

## 2. Endpoint Core Backend (Express ↔ Front-End)
1. **Login / Role:** `POST /api/v1/auth/login`
   - Body: `{ "role": "owner" }` *(pilihan: `owner`, `kasir`, `gudang`)*
2. **Daftar Produk:** `GET /api/v1/products`
3. **Scan Barcode (Satuan / Bundel):** `GET /api/v1/products/scan/:barcode`
4. **Update Stok Gudang:** `PATCH /api/v1/products/:id/stock`
   - Body: `{ "current_stock": 25 }`
5. **Transaksi Kasir (Potong Stok Otomatis):** `POST /api/v1/transactions`
   - Body: `{ "cashier_name": "Kasir 1", "items": [{ "type": "product", "id": 1, "quantity": 2 }, { "type": "bundle", "id": 3, "quantity": 1 }] }`
6. **Daftar Menunggu Approval Owner:** `GET /api/v1/approvals/pending`
7. **Approval 1-Klik Owner:** `PATCH /api/v1/approvals/:type/:id` *(`:type` = `restock` / `bundle`)*
   - Body: `{ "status": "approved" }`

## 3. Endpoint Gateway AI (Express → FastAPI)
1. **Prediksi Restock:** `POST /api/v1/ai/stock-forecast` → FastAPI `POST /ml/predict-restock`
   - Kirim: `{ "product_id": 1, "horizon_days": 7 }`
   - Terima: `{ "product_id": 1, "predicted_stockout_date": "2026-12-03", "recommended_qty": 24 }`
2. **Rekomendasi Bundel 1-Harga:** `POST /api/v1/ai/bundle-suggest` → FastAPI `POST /ml/generate-bundles`
   - Kirim: `{ "min_margin_pct": 10 }`
   - Terima: `{ "bundles": [{ "bundle_name": "Paket Hemat", "bundle_price": 35000, "total_margin": 5500, "items": [{ "product_id": 1, "quantity": 1 }] }] }`
3. **AI Warung Copilot:** `POST /api/v1/ai/copilot` → FastAPI `POST /genai/chat`
   - Kirim: `{ "user_role": "owner", "prompt": "Buatkan promo WA..." }`
   - Terima: `{ "detected_intent": "tanya_produk_promo", "reply": "Halo Bapak/Ibu!..." }`
