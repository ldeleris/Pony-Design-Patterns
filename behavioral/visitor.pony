use "collections"

trait Element
  fun text(): String iso^
  fun ref accept(visitor: Visitor)

class Title is Element
  let _text: String

  new create(text': String) => _text = text'

  fun text(): String iso^ => _text.string()

  fun ref accept(visitor: Visitor) =>
    visitor.visit(this)

class Text is Element
  let _text: String

  new create(text': String) => _text = text'

  fun text(): String iso^ => _text.string()

  fun ref accept(visitor: Visitor) =>
    visitor.visit(this)

class Hyperlink is Element
  let _text: String
  let url: String

  new create(text': String, url': String) => 
    _text = text'
    url = url'

  fun text(): String iso^ => _text.string()

  fun ref accept(visitor: Visitor) =>
    visitor.visit(this)

class Document
  let parts: List[Element]

  new create(parts': List[Element]) =>
    parts = parts'

  fun ref accept(visitor: Visitor) =>
    try
    for i in Range(0, parts.size()) do 
      parts(i)?.accept(visitor)
    end
    end

trait Visitor
  fun ref visit(element: Element)

class HtmlExporterVisitor is Visitor
  let line: String = "\n"
  var builder: String = recover String(0) end

  fun get_html(): String iso^ => builder.string()

  fun ref visit(element: Element) =>
    builder = builder + match element
    | let t: Title => "<h1>" + t.text() + "</h1>" + line
    | let t: Text =>  "<p>" + t.text() + "</p>" + line
    | let h: Hyperlink => "<a href=\"" + h.url + "\">" + h.text() + "</a>" + line
    else
      ""
    end

class PlainTextExporterVisitor is Visitor
  let line: String = "\n"
  var builder: String = recover String(0) end

  fun get_text(): String iso^ => builder.string()

  fun ref visit(element: Element) =>
    builder = builder + match element
    | let t: Title => t.text() + line
    | let t: Text =>  t.text() + line
    | let h: Hyperlink => h.text() + " (" + h.url + ")" + line
    else
      ""
    end


actor VisitorDesign
  new create(env: Env) =>
    env.out.print("Visitor:")

    let document = Document(
      List[Element].from(
        [
          Title("The Visitor Pattern Example")
          Text("The Visitor Pattern helps us add extra functionality without changing the classes.")
          Hyperlink("Go check it online!", "https://www.google.com/")
          Text("Thanks!")
        ]
      )
    )
    let html_exporter: HtmlExporterVisitor = HtmlExporterVisitor
    let plain_text_exporter: PlainTextExporterVisitor = PlainTextExporterVisitor

    env.out.print("Export to html:")
    document.accept(html_exporter)
    env.out.print(html_exporter.get_html())

    env.out.print("Export to plain:")
    document.accept(plain_text_exporter)
    env.out.print(plain_text_exporter.get_text())