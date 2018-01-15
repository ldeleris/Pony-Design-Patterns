use "collections"

trait Memento[T]
  fun _state(): T 
  fun get_state(): T =>
    _state()

/*
trait Caretaker[T]
  fun states(): List[Memento[T]] 
*/

trait Originator[T]
  fun ref create_memento(): Memento[T]
  fun ref restore(memento: Memento[T])

class _TextEditorMemento is Memento[String]
  let _state': String

  new create(state': String) => _state' = state'

  fun _state(): String => _state'

  fun get_state(): String => _state()


class TextEditor is Originator[String]
  var _builder: String = recover String(0) end

  fun ref append(text: String) =>
    _builder = _builder + text

  fun ref delete() =>
    let tmp: ISize = (_builder.size() - 1).isize()
    _builder = _builder.cut(tmp)
  
  fun ref create_memento(): Memento[String] =>
    _TextEditorMemento(_builder)
  
  fun ref restore(memento: Memento[String]) =>
    _builder = memento.get_state() 

  fun ref string(): String => _builder.string()

class TextEditorManipulator //is Caretaker[String]
  let text_editor: TextEditor = TextEditor 
  let _states: List[Memento[String]] = List[Memento[String]]()

  fun ref save() =>
    _states.push(text_editor.create_memento())

  fun ref undo() =>
    try text_editor.restore(_states.pop()?) end

  fun ref append(text: String) =>
    save()
    text_editor.append(text)

  fun ref delete() =>
    save()
    text_editor.delete()
 
  fun ref read_text(): String =>
    text_editor.string()

actor MementoDesign
  new create(env: Env) =>
    env.out.print("Memento:")
    let text_editor_manipulator: TextEditorManipulator = TextEditorManipulator
    text_editor_manipulator.append("This is a chapter about memento.")
    env.out.print("The text is: " + text_editor_manipulator.read_text())
    env.out.print("Deleting 2 characters...")
    text_editor_manipulator.delete()
    text_editor_manipulator.delete()
    env.out.print("The text is: " + text_editor_manipulator.read_text())
    env.out.print("Undoing...")
    text_editor_manipulator.undo()
    env.out.print("The text is: " + text_editor_manipulator.read_text())
    env.out.print("Undoing...")
    text_editor_manipulator.undo()
    env.out.print("The text is: " + text_editor_manipulator.read_text())