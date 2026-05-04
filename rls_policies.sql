-- Politiques RLS pour Habit Tracker
-- Ce fichier contient les règles d'accès pour les tables habits et habit_checks.

-- Activer RLS si ce n'est pas déjà fait.
ALTER TABLE public.habits ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.habit_checks ENABLE ROW LEVEL SECURITY;

-- Habits : l'utilisateur ne peut lire, insérer ou supprimer que ses propres habitudes.
CREATE POLICY IF NOT EXISTS "habits_select_own"
  ON public.habits FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "habits_insert_own"
  ON public.habits FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "habits_delete_own"
  ON public.habits FOR DELETE
  USING (auth.uid() = user_id);

-- Habit checks : l'utilisateur ne peut lire, insérer ou supprimer que ses propres validations.
CREATE POLICY IF NOT EXISTS "checks_select_own"
  ON public.habit_checks FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "checks_insert_own"
  ON public.habit_checks FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "checks_delete_own"
  ON public.habit_checks FOR DELETE
  USING (auth.uid() = user_id);
