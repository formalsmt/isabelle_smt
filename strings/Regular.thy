theory Regular      
  imports Words
begin

(* Regular Languages *) 
type_synonym 'a RegLang = "'a word set"

(* Regular Operations *)
definition concat :: "'a RegLang \<Rightarrow> 'a RegLang \<Rightarrow> 'a RegLang" where "concat R S = {u\<cdot>v |u v. u\<in>R & v\<in>S}"

lemma concat_containment: "a \<in> A \<and> b \<in> B \<Longrightarrow> (a \<cdot> b) \<in> (concat A B)"
  apply(auto simp add: concat_def)
  done

lemma in_concat_if: "w \<in> (concat A B) \<Longrightarrow> \<exists>a b. w = a\<cdot>b \<and> a \<in> A \<and> b \<in> B "
  apply(auto simp add: concat_def)
  done

lemma epsilon_concat_iff: "\<epsilon> \<in> A \<and> \<epsilon> \<in> B \<longleftrightarrow> \<epsilon> \<in> (concat A B)"
  apply(auto simp add: concat_def)
  done


lemma epsilon_in_const_iff: "\<epsilon> \<in> {x} \<longleftrightarrow> x = \<epsilon>"
   apply(auto)
  done

primrec pow:: "'a RegLang \<Rightarrow> nat \<Rightarrow> 'a RegLang" 
  where
   "pow s 0 = {\<epsilon>}"|
   "pow s (Suc n) = concat s (pow s n)"

lemma pow_epsilon:"pow {\<epsilon>} n = {\<epsilon>}"
  apply(induct n)
   apply(simp)
  by (simp add: in_concat_if epsilon_concat_iff concat_def)


lemma pow_zero_empty: "pow {} 0 = {\<epsilon>}"
  by auto

lemma pow_n_empty: "n>0 \<Longrightarrow> pow {} n = {}"
  apply(induct n)
   apply(auto)
  apply(auto simp add: concat_def)
  done
  
definition star :: "'a RegLang \<Rightarrow> 'a RegLang" where "star R = (\<Union>n. (pow R n))"

lemma epsilon_in_star[simp]: "\<epsilon> \<in> star R"
  apply(auto simp add: star_def)
proof -
  have "\<epsilon> \<in> pow R 0" by simp
  then show "EX n. \<epsilon> \<in> pow R n" by (rule exI)
qed

lemma singleton_set: "{w. (length w) = 1} = {v| a v. v = a#\<epsilon>}"
  by (auto simp add: length_Suc_conv)

lemma epsilon_in_pow:"\<exists>n. \<epsilon> \<in> pow r n"
proof -
  have "\<epsilon> \<in> pow r 0" by simp
  thus ?thesis by (rule exI)
qed

lemma star_all_pows:"star r = {w|w n. w \<in> pow r n}"
  apply(auto simp add: star_def)
  done

lemma pow_not_zero:"n>0 \<and> w \<in> pow r n \<Longrightarrow> \<exists>m. w \<in> pow r (Suc m)"
  apply(induct n)
   apply(auto simp add: concat_def)
  done

lemma star_of_epsilon:"star {\<epsilon>} = {\<epsilon>}"
  by (simp add:star_def pow_epsilon)

lemma star_of_empty: "star {} = {\<epsilon>}"
  apply(auto simp add: star_def)
   apply (metis Regular.pow.simps(1) bot_nat_0.not_eq_extremum empty_iff pow_n_empty singletonD)
  by (simp add: epsilon_in_pow)

lemma concat_trans: "w \<in> r \<longleftrightarrow> a#w \<in> concat {a#\<epsilon>} r"
  by (auto simp add: concat_def)



lemma concat_star_subset: "concat L (star L) \<subseteq> (star L)"
proof 
  fix w  assume "w \<in> concat L (star L)"
  then have "w \<in> {w |w n. w \<in> pow L (Suc n)}"  by (auto simp add: concat_def star_all_pows)
  then have "w \<in> {w |w m. w \<in> pow L m}" by blast
  then show "w \<in> (star L)" by (simp only: star_all_pows)
qed


lemma concat_star:"set ws \<subseteq> R \<Longrightarrow> concat_all ws \<in> (star R)"
  apply(induct ws)
  apply(auto)
  using concat_containment concat_star_subset by blast
  

lemma star_subsumes: "v\<cdot>w \<in> concat {v} (star r) \<and> v \<in> r \<Longrightarrow> v\<cdot>w \<in> (star r)"
  apply(auto)
  using concat_star_subset  using concat_containment in_concat_if by blast
  
lemma star_of_singletons_is_univ: "x \<in> star {v|v a. v = a#\<epsilon>}" 
proof (induct x)
  case Nil
  then show ?case by auto
next
  case (Cons a x)
  then have "x \<in> star {uu. \<exists>a v. uu = v \<and> v = a # \<epsilon>}" by auto
  then have "x \<in> star {v |v b. v = b#\<epsilon>}" by auto
  then have fac1:"a#x \<in> concat {a#\<epsilon>} (star {v |v b. v = b#\<epsilon>})" using concat_trans by fastforce
  have fac2: "(a#\<epsilon>) \<in> {v |v b. v = b#\<epsilon>}" by simp
  from fac1 fac2 have "a#x \<in>  (star {v |v b. v = b#\<epsilon>})" using  star_subsumes  by (metis in_concat_if singletonD)
  then show ?case by auto
qed

lemma star_remove_epsilons:"set ws \<subseteq> R \<Longrightarrow> \<exists>wsa. concat_all ws = concat_all wsa \<and> set wsa \<subseteq> R - {\<epsilon>}" (is "?P \<Longrightarrow> \<exists> vs. ?Q vs")
proof
  let ?vs = "filter (%u. u \<noteq> \<epsilon>) ws"
  show "?P \<Longrightarrow> ?Q ?vs" by (induct ws) auto  
qed

lemma x:"w \<in> pow r n \<Longrightarrow> \<exists>ws. w = concat_all ws \<and> set ws \<subseteq> r"
proof (induct n arbitrary: r  w)
  case 0
  then show ?case by (metis Regular.pow.simps(1) concat_all.simps(1) empty_set empty_subsetI singletonD) 
next
  case IH:(Suc n)
  then have "w \<in> concat r (pow r n)" by force
  then have "\<exists>x y. w = x\<cdot>y \<and> x \<in> r \<and> y \<in> (pow r n)" by (force simp add: concat_def)
  then have "\<exists>x y. w = x\<cdot>y \<and> (\<exists>ws. y = concat_all ws \<and> set ws \<subseteq> r)" using IH by fastforce
  then have "\<exists>ws. w = concat_all ws \<and> set ws \<subseteq> r" by (metis IH.hyps \<open>\<exists>x y. w = x \<cdot> y \<and> x \<in> r \<and> y \<in> pow r n\<close> concat_all.simps(2) insert_subset list.set(2))
  then show ?case by simp
qed


lemma star_is_concats: "star R = {concat_all ws|ws. set ws \<subseteq> R}"
  unfolding star_all_pows
  apply(auto simp add: x)
  apply (metis UN_E concat_star star_def)
  done


lemma star_rm_epsilon: "star (R-{\<epsilon>}) = star R"
  unfolding star_is_concats
  apply(auto simp add: star_remove_epsilons)
  done


lemma [simp]:"w \<in> pow R n \<Longrightarrow> w \<in> (star R)"
  apply(auto simp add: star_def)
  done


(* Derivative of regular languages *)
definition deriv:: "'a \<Rightarrow> 'a RegLang \<Rightarrow> 'a RegLang" where  "deriv a R = {v |v. (a#v) \<in> R}" 

primrec derivw:: "'a word \<Rightarrow> 'a RegLang \<Rightarrow> 'a RegLang" where
  "derivw \<epsilon> R = R" |
  "derivw (a#w) R = derivw w (deriv a R)"

definition null:: "'a RegLang \<Rightarrow> 'a RegLang" where "(null L) = (if \<epsilon> \<in> L then {\<epsilon>} else {})"

lemma null_empty[simp]: "null {} = {}" 
  by (simp add: Regular.null_def)

lemma null_epsilon[simp]: "null {\<epsilon>} = {\<epsilon>}"
by (simp add: Regular.null_def)

lemma deriv_empty:"deriv a {} = {}"
  apply(simp add: deriv_def)
  done
 
lemma deriv_const:"deriv a {(b#w)} = (if a = b then {w} else {})"
  apply(auto simp add: deriv_def)
  done

lemma deriv_union: "deriv a (l1 \<union> l2) = (deriv a l1) \<union> (deriv a l2)"
  apply(auto simp add: deriv_def)
  done

lemma deriv_inter: "deriv a (l1 \<inter> l2) = (deriv a l1) \<inter> (deriv a l2)"
  by (auto simp add: deriv_def)

lemma deriv_concat:"deriv a (concat L R) = (concat (deriv a L) R) \<union> (concat (null L) (deriv a R))"
  unfolding deriv_def concat_def null_def
  apply(simp)
  apply(auto)
  by (metis append_eq_Cons_conv)+
  

lemma pow_not_epsilon_is_succ:"n>0 \<and> w \<in> pow R n \<Longrightarrow> \<exists>m. w \<in> pow R (Suc m)"
  apply(induct n)
   apply(auto simp add: pow_def)
  done

lemma star_unroll:"star r = (concat r (star r)) \<union> {\<epsilon>}"
  unfolding concat_def star_all_pows
  apply(auto simp add: pow_not_zero concat_def)
  apply (metis Regular.pow.simps(1) Regular.pow.simps(2) bot_nat_0.not_eq_extremum in_concat_if pow_not_epsilon_is_succ singletonD)
   apply (simp add: epsilon_in_pow)
  using Regular.pow.simps(2) concat_containment by blast
  


lemma deriv_star:"deriv a (star R) = concat (deriv a R) (star R)"
proof -
  have "deriv a (star R) = deriv a (star (R-{\<epsilon>}))" by (auto simp only: star_rm_epsilon)
  also have "... = deriv a ((concat (R-{\<epsilon>}) (star (R-{\<epsilon>}))) \<union> {\<epsilon>})" by (metis star_unroll )
  also have "... = (deriv a (concat (R-{\<epsilon>}) (star (R-{\<epsilon>})))) \<union> (deriv a {\<epsilon>})" by (simp only: deriv_union )
  also have "... = deriv a (concat (R-{\<epsilon>}) (star (R-{\<epsilon>})))" by (simp add: deriv_def)
  also have "... = (concat (deriv a (R-{\<epsilon>})) (star (R-{\<epsilon>}))) \<union> (concat (null (R-{\<epsilon>})) (deriv a (star (R-{\<epsilon>}))))" by (simp add: deriv_concat)
  also have "... = (concat (deriv a (R-{\<epsilon>})) (star (R-{\<epsilon>}))) \<union> (concat {} (deriv a (star (R-{\<epsilon>}))))" by (auto simp add: null_def)
  also have "... =  (concat (deriv a (R-{\<epsilon>})) (star (R-{\<epsilon>})))" by (simp add: concat_def)
  also have "... = (concat (deriv a R) (star (R-{\<epsilon>})))" by (simp add: deriv_def)
  also have "... = (concat (deriv a R) (star R))" by (simp only: star_rm_epsilon)
  finally have "deriv a (star R) = concat (deriv a R) (star R)" by simp
  then show ?thesis by simp
qed


theorem deriv_correct:"w \<in> deriv a R \<longleftrightarrow> (a#w) \<in> R"
  apply(auto simp add: deriv_def)
  done


end