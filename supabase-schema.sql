-- Execute no SQL Editor do Supabase.
create table if not exists public.transactions (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 date date not null,
 description text not null,
 amount numeric(14,2) not null check (amount >= 0),
 type text not null check (type in ('income','expense','transfer')),
 category text not null default 'Outros',
 source text,
 installment_number integer,
 installment_count integer,
 created_at timestamptz not null default now(),
 constraint installment_valid check (
  (installment_number is null and installment_count is null) or
  (installment_number >= 1 and installment_count >= installment_number)
 )
);
alter table public.transactions enable row level security;
drop policy if exists "Users manage own transactions" on public.transactions;
create policy "Users manage own transactions" on public.transactions for all to authenticated
using (auth.uid()=user_id) with check (auth.uid()=user_id);
create index if not exists transactions_user_date_idx on public.transactions(user_id,date desc);
alter table public.transactions add column if not exists installment_number integer;
alter table public.transactions add column if not exists installment_count integer;
alter table public.transactions drop constraint if exists transactions_type_check;
alter table public.transactions add constraint transactions_type_check check (type in ('income','expense','transfer'));
