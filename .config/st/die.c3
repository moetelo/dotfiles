// import std::io;
// import std::thread;
import libc;

fn void die(
    ZString errstr,
    ZString arg1,
    ZString arg2 = "\0",
    ZString arg3 = "\0",
) @extern("die") @export {
    libc::fprintf(libc::stderr(), errstr, arg1, arg2, arg3);
    libc::exit(1);
}
