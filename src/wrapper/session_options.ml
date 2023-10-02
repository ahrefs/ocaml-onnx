open! Base
open! Import
include Wrappers.SessionOptions

let create ?inter_op_num_threads ?intra_op_num_threads ?cuda_options () =
  let t = create () in
  Option.iter inter_op_num_threads ~f:(fun threads ->
    set_inter_op_num_threads t ~threads:(Some threads));
  Option.iter intra_op_num_threads ~f:(fun threads ->
    set_intra_op_num_threads t ~threads:(Some threads));
  let () =
    Option.iter cuda_options ~f:(fun opt -> append_execution_provider_cuda t opt)
  in
  (* match cuda_options with
    | None -> ()
    | Some opt ->
      (try append_execution_provider_cuda t opt with
       | Failure err -> Stdio.prerr_endline @@ "Warning: failed to add CUDA EP: " ^ err) *)
  t

let create_cuda_options_exn ?device_id () =
  (* https://onnxruntime.ai/docs/execution-providers/CUDA-ExecutionProvider.html#configuration-options *)
  let t = create_cuda_options () in
  let kvs = ref [] in
  let () =
    match device_id with
    | None -> ()
    | Some id -> kvs := ("device_id", Int.to_string id) :: !kvs
  in
  update_cuda_options t !kvs;
  t

let create_cuda_options ?device_id () =
  try Ok (create_cuda_options_exn ?device_id ()) with
  | Failure err -> Error err
