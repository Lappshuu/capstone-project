-- 1. Tabel Master Produk
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    sku_barcode VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL, -- contoh: 'sembako', 'minuman', 'pecah_belah', 'snack'
    unit_price NUMERIC(12, 2) NOT NULL CHECK (unit_price >= 0),
    cost_price NUMERIC(12, 2) NOT NULL CHECK (cost_price >= 0),
    current_stock INTEGER NOT NULL DEFAULT 0 CHECK (current_stock >= 0),
    min_stock_threshold INTEGER NOT NULL DEFAULT 5 CHECK (min_stock_threshold >= 0),
    status_velocity VARCHAR(20) NOT NULL DEFAULT 'normal' 
        CHECK (status_velocity IN ('fast_moving', 'normal', 'dead_stock')),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabel Paket Bundel 1-Harga (Output Bundle-Clear AI)
CREATE TABLE bundles (
    id SERIAL PRIMARY KEY,
    bundle_barcode VARCHAR(50) UNIQUE NOT NULL,
    bundle_name VARCHAR(150) NOT NULL,
    bundle_price NUMERIC(12, 2) NOT NULL CHECK (bundle_price > 0),
    total_margin NUMERIC(12, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending_approval' 
        CHECK (status IN ('pending_approval', 'approved', 'rejected')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabel Detail Komponen Item dalam Paket Bundel
CREATE TABLE bundle_items (
    id SERIAL PRIMARY KEY,
    bundle_id INTEGER NOT NULL REFERENCES bundles(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0)
);

-- 4. Tabel Header Transaksi Kasir (POS)
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    total_amount NUMERIC(12, 2) NOT NULL CHECK (total_amount >= 0),
    cashier_name VARCHAR(100) DEFAULT 'Kasir Utama',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Tabel Detail Item Transaksi (Bisa item satuan ATAU paket bundel)
CREATE TABLE transaction_items (
    id SERIAL PRIMARY KEY,
    transaction_id INTEGER NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id) ON DELETE RESTRICT,
    bundle_id INTEGER REFERENCES bundles(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    subtotal NUMERIC(12, 2) NOT NULL CHECK (subtotal >= 0),
    -- Memastikan baris ini merujuk ke salah satu: produk satuan atau bundel
    CONSTRAINT chk_item_or_bundle CHECK (
        (product_id IS NOT NULL AND bundle_id IS NULL) OR 
        (product_id IS NULL AND bundle_id IS NOT NULL)
    )
);

-- 6. Tabel Rekomendasi Kulakan Ulang (Output Smart Stock-Up AI)
CREATE TABLE restock_recommendations (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    predicted_stockout_date DATE NOT NULL,
    recommended_qty INTEGER NOT NULL CHECK (recommended_qty > 0),
    approval_status VARCHAR(20) NOT NULL DEFAULT 'pending_approval' 
        CHECK (approval_status IN ('pending_approval', 'approved', 'rejected')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. Tabel Riwayat Layanan Gen AI (Wajib Sesuai Rubrik Penilaian)
CREATE TABLE ai_copilot_logs (
    id SERIAL PRIMARY KEY,
    user_role VARCHAR(30) NOT NULL, -- 'owner', 'kasir', 'gudang'
    detected_intent VARCHAR(50),    -- 'cek_stok_restock', 'rekomendasi_bundling', 'tanya_produk_promo', 'keluhan_operasional', 'out_of_context'
    user_prompt TEXT NOT NULL,
    ai_response TEXT NOT NULL,
    response_time_ms INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexing untuk mempercepat query POS & Dashboard
CREATE INDEX idx_products_barcode ON products(sku_barcode);
CREATE INDEX idx_bundles_barcode ON bundles(bundle_barcode);
CREATE INDEX idx_transactions_date ON transactions(created_at);
