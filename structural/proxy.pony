use "files"
use "collections"

interface FileReader
  fun ref read_file_contents(): String

class FileReaderReal is FileReader
  let _env: Env
  let file_name: String
  let contents: String

  new create(env: Env, file_name': String) => 
    _env = env
    file_name = file_name'
    let f = {(file_name': String): (None | String) =>
      var s: String iso = recover String(0) end
      try
        let path = FilePath(_env.root as AmbientAuth, file_name')?
        match OpenFile(path)
        | let file: File =>
          let lines: FileLines = FileLines(file)
          while lines.has_next() do
            s.append(lines.next() + "\n")
          end
          s
        else
          _env.out.print("Error opening file '" + file_name' + "'")
          ""
        end      
      end } 
    contents = match f(file_name')
    | None => "Erreur de lecture"
    | let str: String => str 
    end
    _env.out.print("Finished reading the actual file: " + file_name)  

  fun ref read_file_contents(): String => contents

class FileReaderProxy is FileReader
  let file_name: String
  var _file_reader: (None | FileReaderReal) = None
  let _env: Env

  new create(env: Env, file_name': String) =>
    file_name = file_name'
    _env = env

  fun ref read_file_contents(): String =>
    match _file_reader
    | None => _file_reader = FileReaderReal(_env,file_name)
    end
    try
      (_file_reader as FileReaderReal).read_file_contents()
    else
      ""
    end




actor Proxy
  new create(env: Env) =>
    env.out.print("Proxy:")
    let files: List[(String, FileReader)] = List[(String, FileReader)].from([
      ("file1", FileReaderProxy(env, "C:\\Users\\Laurent\\pony\\patterns\\file1.txt"))
      ("file2", FileReaderProxy(env, "C:\\Users\\Laurent\\pony\\patterns\\file2.txt"))
      ("file3", FileReaderProxy(env, "C:\\Users\\Laurent\\pony\\patterns\\file3.txt"))
      ("file4", FileReaderReal(env, "C:\\Users\\Laurent\\pony\\patterns\\file1.txt"))])
    env.out.print("Created the list. You should have seen file1.txt read because it wasn't used in a proxy.")
    try
      env.out.print("Reading file1.txt from the proxy: " +
        files(0)?._2.read_file_contents())
      env.out.print("Reading file3.txt from the proxy: " +
        files(2)?._2.read_file_contents())
      env.out.print("Reading file1.txt from the proxy: " +
        files(0)?._2.read_file_contents())
    end