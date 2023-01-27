theory Words        
  imports Main
begin

no_notation Groups.times_class.times (infixl "*" 70)



datatype 'a word = Epsilon | Con "'a" "'a word" (infixr "." 67) 
print_definitions
print_theorems
print_defn_rules


value "CHR ''a'' . CHR ''b'' . CHR ''c'' . Epsilon"


(* Basic Operations *)

primrec at :: "'a word \<Rightarrow> nat \<Rightarrow> 'a option"
  where 
  "at Epsilon i = None" |
  "at (a . w) i = (if i = 0 then Some a else at w (i-1))"

primrec size :: "'a word \<Rightarrow> nat"
  where
  "size Epsilon = 0" |
  "size (a . w) = Suc (size w)"

lemma [simp]:"(at (a . w) 0) = (Some a)"
  apply(auto)
  done

primrec concat:: "'a word \<Rightarrow> 'a word \<Rightarrow> 'a word" (infixr "*" 100)
  where
    "concat Epsilon v = v" |
    "concat (Con a u)  v = (Con a (concat u v))" 

primrec concatn:: "'a word list \<Rightarrow> 'a word"
  where
  "concatn [] = Epsilon" |
  "concatn (w#ws) = w*(concatn ws)"

primrec rev :: "'a word \<Rightarrow> 'a word"
  where
    "rev Epsilon = Epsilon" |
    "rev (Con a u) = concat (rev u) (a . Epsilon)"

primrec fac :: "'a word \<Rightarrow> nat \<Rightarrow> nat \<Rightarrow> 'a word"
  where
   "fac Epsilon s l  = Epsilon" |
   "fac (Con a w) s l = (if s=0 then (Con a (fac w 0 (l-1))) else (fac w (s-1) l))"

primrec repeat :: "'a word \<Rightarrow> nat \<Rightarrow> 'a word" 
  where
  "repeat w 0 = Epsilon" |
  "repeat w (Suc n) = w * (repeat w n)"


primrec starts_with::"'a word \<Rightarrow> 'a \<Rightarrow> bool"
  where 
  "starts_with Epsilon a = False"|
  "starts_with (a . w) b = (a=b)"


definition is_prefix:: "'a word \<Rightarrow> 'a word \<Rightarrow> bool" where "is_prefix v w = ((fac w 0 (size v)) = v)"
definition is_suffix:: "'a word \<Rightarrow> 'a word \<Rightarrow> bool" where "is_suffix v w = is_prefix (rev v) (rev w)" 
  

lemma epsi_concat[simp]: "Epsilon = u * v \<longleftrightarrow> ((u = Epsilon) \<and> (v = Epsilon))"
  apply(induct u)
  apply(auto)
  done

lemma epsilon_concat_commut: "w * Epsilon = Epsilon * w"
  apply(induct w)
   apply(auto)
  done

lemma epsilon_neutrality[simp]: "w * Epsilon = w" 
  apply(auto simp add: epsilon_concat_commut)
  done

(* Associativity of word concatenation *)
lemma concat_associativity [simp]: "(u * v) * w = u * (v * w)" 
  apply(induct u)
   apply(auto)
  done

(* Associativity of word concatenation *)
lemma concat_associativity2: "u * (v * w) = (u * v) * w" 
  apply(induct u)
   apply(auto)
  done

lemma eq_prefix_equals: "(a . w) = u*v \<longleftrightarrow>
   (u = Epsilon \<and> (a . w) = v \<or> (\<exists>v'. u = (a . v') \<and> w = v'*v))"
  by(cases u) auto

lemma rev_concat [simp]: "rev (w * v) = (rev v) * (rev w)"
  apply(induct_tac w)
   apply(auto simp add: epsilon_neutrality)
  done
 
theorem rev_rev: "\<And> w. rev(rev w) = w"
  apply(induct_tac w)
  apply(auto)
  done



(* Conversion *)
primrec of_list:: "'a list \<Rightarrow> 'a word"
  where
  "of_list [] = Epsilon" |
  "of_list (x#xs) = x . (of_list xs)"


end





