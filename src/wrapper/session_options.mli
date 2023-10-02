open! Base
open! Import

type cuda_options = Wrappers.SessionOptions.cuda_options
type t = Wrappers.SessionOptions.t

val create_cuda_options : ?device_id:int -> unit -> (cuda_options, string) Result.t

val create
  :  ?inter_op_num_threads:int
  -> ?intra_op_num_threads:int
  -> ?cuda_options:cuda_options
  -> unit
  -> t
