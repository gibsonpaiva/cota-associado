// Configurações globais do Supabase para Valoriza Car
const SUPABASE_CONFIG = {
  url: 'https://vmcfimsfqtbfsovpzwml.supabase.co',
  publishableKey: 'sb_publishable_154zsERKBGrEzzDrRA4CfQ_dZz2G3so'
};

// Inicializa a instância do Supabase caso a biblioteca JS esteja carregada
let supabaseClient = null;
if (window.supabase && typeof window.supabase.createClient === 'function') {
  supabaseClient = window.supabase.createClient(SUPABASE_CONFIG.url, SUPABASE_CONFIG.publishableKey, {
    auth: {
      persistSession: true,
      autoRefreshToken: true,
      detectSessionInUrl: true
    }
  });
}

// SQL pronto para criar a tabela no Supabase caso o usuário precise
const SUPABASE_SETUP_SQL = `-- 1. Criar tabela de cotações
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
  status TEXT DEFAULT 'Novo'
);

-- 2. Habilitar Row Level Security (RLS)
ALTER TABLE public.cotacoes ENABLE ROW LEVEL SECURITY;

-- 3. Permitir que qualquer visitante insira sua cotação
CREATE POLICY "Permitir insercao publica de cotacoes"
ON public.cotacoes
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

-- 4. Permitir que usuários logados (você no painel) leiam todas as cotações
CREATE POLICY "Permitir leitura para autenticados"
ON public.cotacoes
FOR SELECT
TO authenticated
USING (true);

-- 5. Permitir que usuários logados atualizem status das cotações
CREATE POLICY "Permitir atualizacao para autenticados"
ON public.cotacoes
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- 6. Permitir que usuários logados excluam cotações
CREATE POLICY "Permitir exclusao para autenticados"
ON public.cotacoes
FOR DELETE
TO authenticated
USING (true);

-- 7. Ativar Realtime para atualizar a tela ao vivo
ALTER PUBLICATION supabase_realtime ADD TABLE public.cotacoes;
`;
