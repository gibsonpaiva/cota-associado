-- ========================================================
-- VALORIZA CAR - SCHEMA SUPABASE PARA COTAÇÕES
-- ========================================================
-- Instruções:
-- 1. Acesse o painel do seu Supabase: https://supabase.com/dashboard/project/vmcfimsfqtbfsovpzwml
-- 2. No menu lateral esquerdo, clique no ícone "SQL Editor" (ícone com terminal/código)
-- 3. Clique em "+ New query", cole todo este código abaixo e clique em "Run" (botão verde no canto inferior direito)
-- ========================================================

-- 1. Criação da tabela de cotações
CREATE TABLE IF NOT EXISTS public.cotacoes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT now(),
  nome TEXT NOT NULL,
  whatsapp TEXT NOT NULL,
  cpf TEXT,
  fipe_faixa TEXT,
  fipe_adicional NUMERIC DEFAULT 0,
  reboque TEXT,
  reboque_valor NUMERIC DEFAULT 0,
  opcionais JSONB DEFAULT '[]'::jsonb,
  valor_total NUMERIC NOT NULL,
  status TEXT DEFAULT 'Novo',
  motivo_cancelamento TEXT
);

-- Garantir adição da coluna caso a tabela já exista
ALTER TABLE public.cotacoes ADD COLUMN IF NOT EXISTS motivo_cancelamento TEXT;

-- 2. Habilitação de Segurança por Nível de Linha (RLS)
ALTER TABLE public.cotacoes ENABLE ROW LEVEL SECURITY;

-- 3. Política: Qualquer visitante pode cadastrar uma cotação (INSERT)
DROP POLICY IF EXISTS "Permitir insercao publica de cotacoes" ON public.cotacoes;
CREATE POLICY "Permitir insercao publica de cotacoes"
ON public.cotacoes
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

-- 4. Política: Usuários autenticados (você logado) podem visualizar todas as cotações (SELECT)
DROP POLICY IF EXISTS "Permitir leitura para autenticados" ON public.cotacoes;
CREATE POLICY "Permitir leitura para autenticados"
ON public.cotacoes
FOR SELECT
TO authenticated
USING (true);

-- 5. Política: Usuários autenticados podem atualizar o status da cotação (UPDATE)
DROP POLICY IF EXISTS "Permitir atualizacao para autenticados" ON public.cotacoes;
CREATE POLICY "Permitir atualizacao para autenticados"
ON public.cotacoes
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- 6. Política: Usuários autenticados podem excluir cotações (DELETE)
DROP POLICY IF EXISTS "Permitir exclusao para autenticados" ON public.cotacoes;
CREATE POLICY "Permitir exclusao para autenticados"
ON public.cotacoes
FOR DELETE
TO authenticated
USING (true);

-- 7. Adicionar à publicação de Realtime do Supabase (para atualizar a tela ao vivo sem recarregar)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' 
    AND schemaname = 'public' 
    AND tablename = 'cotacoes'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.cotacoes;
  END IF;
END $$;
