# Meu Controle Financeiro — versão aprimorada

## Recursos
- Autenticação Supabase e banco PostgreSQL com RLS.
- Importação CSV, OFX, XLSX e extração heurística de texto PDF.
- Prévia editável de categoria e tipo (receita, despesa, transferência).
- Pagamento de fatura reconhecido por palavras-chave e classificado como transferência para evitar duplicidade no balanço.
- Deduplicação simples por data + descrição + valor + tipo.
- Identificação de parcelas em descrições como "Parcela 03/10".
- Resumo anual mês a mês, categorias e exportação CSV.

## Publicação gratuita
Arquitetura sugerida: Cloudflare Pages (frontend) + Supabase Free (login e banco). O Cloudflare Pages Free documenta até 500 builds/mês e até 20.000 arquivos por site. O Supabase Free informa 500 MB de banco, 1 GB de armazenamento e pausa de projetos inativos após uma semana. Consulte os limites atuais: https://developers.cloudflare.com/pages/platform/limits/ e https://supabase.com/pricing.

1. Crie um projeto Supabase.
2. Execute `supabase-schema.sql` no SQL Editor.
3. Em Authentication > URL Configuration, configure a URL do site após publicar.
4. Em `index.html`, substitua `COLE_AQUI_A_URL_DO_SEU_PROJETO` e `COLE_AQUI_A_CHAVE_ANON_PUBLIC`.
5. Publique a pasta no Cloudflare Pages conectando um repositório GitHub. Build command vazio; diretório de saída `/`.
6. Teste login, confirmação de e-mail, importação e exportação.

Nunca coloque a chave `service_role` no frontend. Use somente a anon/public key com RLS habilitado.

## Limitações importantes
- O PDF é extraído por heurística de texto; documentos escaneados precisam de OCR e layouts variam por banco. Revise tudo antes de salvar.
- O pagamento de fatura só é reconhecido por palavras-chave. Confirme manualmente o tipo na prévia.
- O parcelamento só é identificado quando a descrição contém padrão como 03/10; a lista mostra compras encontradas, mas não projeta compromissos futuros.
- A deduplicação é simples e não reconhece estornos nem descrições equivalentes.
- Não há sincronização bancária automática nem retenção de arquivos originais.
- Antes de usar dados reais, teste RLS com duas contas distintas e use apenas o domínio HTTPS publicado.
