let Gag = {

  init(socket, element){ if(!element){ return }
    let slug = element.getAttribute("data-slug")
    socket.connect()
    this.onReady(slug, socket)
  },

  onReady(slug, socket){
    let msgContainer = document.getElementById("msg-container")
    let msgUser      = document.getElementById("msg-user")
    let msgInput     = document.getElementById("msg-input")
    let postButton   = document.getElementById("msg-submit")
    let gagDiv   = document.getElementById("gag")
    let gagChannel   = socket.channel("gag:" + slug)

    postButton.addEventListener("click", e => {
      if (msgInput.value === "" || msgUser.value === "") {
        alert("Empty field")
        return
      }
      let payload = {body: msgInput.value, user: msgUser.value}
      gagChannel.push("new_comment", payload)
                .receive("error", e => console.log(e))
      msgInput.value = ""
    })

    gagChannel.on("new_comment", (resp) => {
      this.renderComment(msgContainer, resp)
    })

    gagChannel.join()
      .receive("ok", (resp) => {
        this.renderComments(msgContainer, resp.comments)
        this.renderGag(gagDiv, resp.current_meme)
      })
      .receive("error", reason => console.log("join failed", reason) )
  },

  renderGag(gagDiv, current_gag) {
    console.log(current_gag)
    gagDiv.innerHTML = `
    <h3>${current_gag.caption}</h3>
    <img src="${current_gag.images.large}" />
    <div>
      upvotes: ${current_gag.votes.count}
    </div>
    `
  },

  renderComments(msgContainer, comments) {
    comments.filter( comment => {
      this.renderComment(msgContainer, comment)
    })
  },

  renderComment(msgContainer, {body, user}) {
    let template = document.createElement("div")

    template.innerHTML = `
    <a href="#">
      <b>${this.esc(user)}</b>: ${this.esc(body)}
    </a>
    `
    msgContainer.insertBefore(template, msgContainer.firstChild)
    msgContainer.scrollTop = msgContainer.scrollHeight
  },

  esc(str) {
    let div = document.createElement("div")
    div.appendChild(document.createTextNode(str))
    return div.innerHTML
  },
}
export default Gag
