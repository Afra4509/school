-- ============================================================
--  SETUP SUPABASE — Sistem Absensi SMADA
--  Jalankan query ini di Supabase SQL Editor
-- ============================================================

-- 1. Buat tabel absensi
CREATE TABLE IF NOT EXISTS public.absensi (
  id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  nama        text NOT NULL,
  kelas       text NOT NULL,
  tanggal     date NOT NULL,
  status      text NOT NULL CHECK (status IN ('Hadir', 'Tidak Hadir', 'Izin', 'Sakit')),
  alasan      text,
  jam         text,
  created_at  timestamptz DEFAULT now()
);

-- 2. Aktifkan Row Level Security
ALTER TABLE public.absensi ENABLE ROW LEVEL SECURITY;

-- 3. Izinkan siapa saja (anon) insert — untuk form absensi siswa
CREATE POLICY "Allow anon insert"
  ON public.absensi FOR INSERT
  TO anon
  WITH CHECK (true);

-- 4. Izinkan siapa saja (anon) select — untuk dashboard guru
--    (login admin dilakukan di front-end, bukan Supabase Auth)
CREATE POLICY "Allow anon select"
  ON public.absensi FOR SELECT
  TO anon
  USING (true);

-- 5. Index untuk performa query berdasarkan tanggal dan kelas
CREATE INDEX IF NOT EXISTS idx_absensi_tanggal ON public.absensi (tanggal);
CREATE INDEX IF NOT EXISTS idx_absensi_kelas   ON public.absensi (kelas);
CREATE INDEX IF NOT EXISTS idx_absensi_status  ON public.absensi (status);

-- ============================================================
--  CARA PENGGUNAAN
-- ============================================================
--
--  1. Buka https://supabase.com dan buat project baru
--
--  2. Pergi ke: Project > SQL Editor > New Query
--     Paste seluruh isi file ini, lalu klik RUN
--
--  3. Pergi ke: Project > Settings > API
--     Salin:
--       - Project URL         → masukkan ke SUPABASE_URL di config.js
--       - anon public key     → masukkan ke SUPABASE_ANON_KEY di config.js
--
--  4. Buka config.js dan ganti nilai placeholder:
--       const SUPABASE_URL      = "https://xxxxxx.supabase.co";
--       const SUPABASE_ANON_KEY = "eyJxxxxxx...";
--
--  5. Jalankan website (bisa pakai Live Server VSCode, atau
--     deploy ke Netlify/Vercel/GitHub Pages)
--
-- ============================================================
