open! Base
open! Import
include Wrappers.SessionOptions

let create ?inter_op_num_threads ?intra_op_num_threads ?(with_cuda = false) () =
  let t = create () in
  Option.iter inter_op_num_threads ~f:(fun threads ->
    set_inter_op_num_threads t ~threads:(Some threads));
  Option.iter intra_op_num_threads ~f:(fun threads ->
    set_intra_op_num_threads t ~threads:(Some threads));
  if with_cuda
  then (
    try append_execution_provider_cuda t with
    | Failure err -> Stdio.prerr_endline @@ "Warning: failed to add CUDA EP: " ^ err);
  t
