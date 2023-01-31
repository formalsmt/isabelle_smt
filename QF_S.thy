theory QF_S
  imports RegEx Words Core
begin


abbreviation str_concat:: "'a word \<Rightarrow> 'a word  \<Rightarrow> 'a word"  where "(str_concat) u v \<equiv> u@v" 
abbreviation str_len:: "'a word \<Rightarrow> int" where  "str_len w \<equiv> of_nat (length w)"
abbreviation str_at:: "'a word \<Rightarrow> int \<Rightarrow> 'a word" where "str_at w i \<equiv> (at w (nat i))"

abbreviation str_substr:: "'a word \<Rightarrow> int \<Rightarrow> int \<Rightarrow> 'a word"  where "str_substr a i n \<equiv>  fac a (nat i) (nat n)"
abbreviation str_prefixof:: "'a word \<Rightarrow> 'a word \<Rightarrow> bool" where "str_prefixof \<equiv> Words.is_prefix"
abbreviation str_suffixof:: "'a word \<Rightarrow> 'a word \<Rightarrow> bool" where "str_suffixof \<equiv> Words.is_suffix"
abbreviation str_contains:: "'a word \<Rightarrow> 'a word \<Rightarrow> bool" where "str_contains \<equiv> Words.contains"
abbreviation str_indexof:: "'a word \<Rightarrow> 'a word \<Rightarrow> int \<Rightarrow> int" 
  where "str_indexof h n s \<equiv> of_nat (find h n)"

(* Regular Expression Functions *)

abbreviation str_to_re:: "'a word \<Rightarrow> 'a regex" where "str_to_re w \<equiv> regex.Const w"
abbreviation str_in_re:: "'a word \<Rightarrow> 'a regex \<Rightarrow> bool" where "str_in_re w R \<equiv> contains w R"
abbreviation re_none:: "'a regex" where "re_none \<equiv> regex.None"
abbreviation re_allchar:: "'a regex" where "re_allchar \<equiv> regex.Any"
(* missing:  re_all*)

abbreviation re_concat:: "'a regex \<Rightarrow> 'a regex \<Rightarrow> 'a regex"  where "re_concat r1 r2 \<equiv> Concat r1 r2"
abbreviation re_union:: "'a regex \<Rightarrow> 'a regex \<Rightarrow> 'a regex" where "re_union r1 r2 \<equiv> Union r1 r2"
(* missing: re_inter, re_com, re_diff, re_plus, re_opt, re_range, re_pow, re_loop *)
abbreviation re_star:: "'a regex \<Rightarrow>'a regex" where "re_star r \<equiv> Star r"
abbreviation re_plus:: "'a regex \<Rightarrow> 'a regex" where "re_plus r \<equiv> Plus r"


end