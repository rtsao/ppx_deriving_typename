module PL   = Ppxlib
module A    = PL.Ast_builder.Default
module D    = PL.Deriving
module G    = D.Generator
module P    = Printf

(*
 *  Given a location, path and a list of type declarations which have
 *  been annotated with [@@deriving typename], generates a structure:
 *  let foo_name = "foo"
 *  Where foo is the name of the type.
 *)
let derive_typename ~(loc : PL.location)
                    ~(path : string)
                    ((_ : PL.rec_flag), (tdls : PL.type_declaration list))
                    : PL.structure =
  ignore path;
  let open PL in
  let from_type_decl (td : PL.type_declaration) =
    let name = P.sprintf "%s_name" td.ptype_name.txt in
    let binding = A.pvar ~loc name in
    let btype = [%type: string] in
    let pat = A.ppat_constraint ~loc binding btype in
    let expr = A.estring ~loc (td.ptype_name.txt) in
    let vb = A.value_binding ~loc ~pat ~expr in
    A.pstr_value ~loc PL.Nonrecursive [vb]
  in
  List.map from_type_decl tdls

(* Register *)
let () =
  let str_type_decl = G.make_noarg derive_typename in
  D.ignore (D.add "typename" ~str_type_decl)
