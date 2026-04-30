-- ============================================================
-- Habit Tracker — Schéma Supabase complet
-- À exécuter dans le SQL Editor du dashboard Supabase
-- Ordre d'exécution : ce fichier en entier, de haut en bas.
-- ============================================================


-- ─────────────────────────────────────────────────────────────
-- 1. TABLES
-- ─────────────────────────────────────────────────────────────

-- Table des habitudes
CREATE TABLE IF NOT EXISTS public.habits (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name        TEXT NOT NULL CHECK (char_length(name) BETWEEN 1 AND 60),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table des validations quotidiennes
-- checked_date stocke la date UTC (type DATE, pas TIMESTAMP)
-- La contrainte UNIQUE empêche la double validation d'une habitude le même jour
CREATE TABLE IF NOT EXISTS public.habit_checks (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  habit_id      UUID NOT NULL REFERENCES public.habits(id) ON DELETE CASCADE,
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  checked_date  DATE NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Garde-fou DB : une seule validation par habitude par jour
  CONSTRAINT unique_habit_check_per_day UNIQUE (habit_id, checked_date)
);


-- ─────────────────────────────────────────────────────────────
-- 2. INDEX (performance)
-- ─────────────────────────────────────────────────────────────

-- Accélérer la récupération des habitudes par utilisateur
CREATE INDEX IF NOT EXISTS idx_habits_user_id
  ON public.habits(user_id);

-- Accélérer les requêtes de suivi quotidien
CREATE INDEX IF NOT EXISTS idx_habit_checks_habit_date
  ON public.habit_checks(habit_id, checked_date);

CREATE INDEX IF NOT EXISTS idx_habit_checks_user_id
  ON public.habit_checks(user_id);


-- ─────────────────────────────────────────────────────────────
-- 3. ROW LEVEL SECURITY (RLS)
-- ─────────────────────────────────────────────────────────────

-- Activer RLS — OBLIGATOIRE avant de créer les policies
ALTER TABLE public.habits      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.habit_checks ENABLE ROW LEVEL SECURITY;

-- ── Policies pour habits ─────────────────────────────────────

-- SELECT : un user ne voit que ses propres habitudes
CREATE POLICY "habits_select_own"
  ON public.habits FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT : un user ne peut créer des habitudes que pour lui-même
CREATE POLICY "habits_insert_own"
  ON public.habits FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- DELETE : un user ne peut supprimer que ses propres habitudes
CREATE POLICY "habits_delete_own"
  ON public.habits FOR DELETE
  USING (auth.uid() = user_id);

-- ── Policies pour habit_checks ───────────────────────────────

-- SELECT : un user ne voit que ses propres validations
CREATE POLICY "checks_select_own"
  ON public.habit_checks FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT : un user ne peut valider que ses propres habitudes
CREATE POLICY "checks_insert_own"
  ON public.habit_checks FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- DELETE : un user ne peut supprimer que ses propres validations
CREATE POLICY "checks_delete_own"
  ON public.habit_checks FOR DELETE
  USING (auth.uid() = user_id);


-- ─────────────────────────────────────────────────────────────
-- 4. REALTIME
-- ─────────────────────────────────────────────────────────────
-- Activer Realtime pour synchronisation multi-device instantanée.
-- Ces commandes ajoutent les tables à la publication Supabase Realtime.

ALTER PUBLICATION supabase_realtime ADD TABLE public.habits;
ALTER PUBLICATION supabase_realtime ADD TABLE public.habit_checks;


-- ─────────────────────────────────────────────────────────────
-- 5. VÉRIFICATION (optionnel — à exécuter séparément)
-- ─────────────────────────────────────────────────────────────
-- Vérifier que les tables existent
-- SELECT table_name FROM information_schema.tables
--   WHERE table_schema = 'public';

-- Vérifier que RLS est activé
-- SELECT tablename, rowsecurity FROM pg_tables
--   WHERE schemaname = 'public';

-- Vérifier les policies
-- SELECT * FROM pg_policies WHERE schemaname = 'public';

-- Test des policies : simuler un autre user (remplacer l'UUID)
-- SET request.jwt.claims = '{"sub": "UUID_AUTRE_USER"}';
-- SELECT * FROM public.habits; -- doit retourner 0 lignes
