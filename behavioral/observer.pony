use "collections"

interface Observer[T]
  fun handle_update(subject: T)

interface val Observable[T]

  fun ref add_observer(observer: Observer[T])

  fun ref notify_observers()
 
class User is Observer[Post]
  let name: String
  let _env: Env

  new create(env: Env, name': String) =>
    name = name'
    _env = env

  fun handle_update(subject: Post) =>
    var comments: String = recover "[" end
    try
    comments = comments + subject.comments(0)?.string()
    for i in Range(1, subject.comments.size()) do
      comments = comments + ", " + subject.comments(i)?.string()
    end 
    comments = comments + "]"
    end
    _env.out.print("Hey, I'm " + name + ". The post got some new comments: " +
      comments )

  fun string(): String iso^ =>
    ("User(" + name + ")").string()

class Comment
  let user: User
  let text: String

  new create(user': User, text': String) =>
    user = user'
    text = text'

  fun string(): String iso^ =>
    ("Comment(" + user.string() + ", " + text + ")").string()

class Post is Observable[Post]
  let user: User
  let text: String
  let comments: List[Comment] = List[Comment]()
  let observers: List[Observer[Post]] = List[Observer[Post]]()

  new create(user': User, text': String) =>
    user = user'
    text = text'

  fun ref add_comment(comment: Comment) =>
    comments.push(comment)
    notify_observers()

  fun ref add_observer(observer: Observer[Post]) =>
    observers.push(observer)

  fun ref notify_observers() =>
    for i in Range(0, observers.size()) do
    try
      observers(i)?.handle_update(this)
    end
    //None
    end


actor ObserverDesign
  new create(env: Env) =>
    env.out.print("Observer:")
    let user1: User  = User(env, "Yvan")
    let user2: User  = User(env, "Maria")
    let user3: User  = User(env, "John")

    env.out.print("Create a Post")
    let post: Post  = Post(user1, "This is a post about the observer design pattern.")
    
    env.out.print("Add a comment.")
    post.add_comment(Comment(user1, "I hope you like the post!"))
    
    env.out.print("John and Maria subscribe to the comments.")
    post.add_observer(user2)
    post.add_observer(user3)
    env.out.print("Add a comment.")
    post.add_comment(Comment(user1, "Why are you so quiet? Do you like it?"))
    env.out.print("Add a comment.")
    post.add_comment(Comment(user2, "It is amazing! Thanks!"))
    
