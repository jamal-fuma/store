create function store.invoice_delete(integer,
	out ok boolean, out js json) as $$
declare
	err text;
begin
	js = row_to_json(r.*) from store.invoice_view r where id = $1;
	ok = true;
	if js is null then
		ok = false;
		js = '{}';
	else
		delete from invoices where id = $1;
	end if;
exception
	when others then get stacked diagnostics err = message_text;
	js = json_build_object('error', err);
	ok = false;
end;
$$ language plpgsql;
