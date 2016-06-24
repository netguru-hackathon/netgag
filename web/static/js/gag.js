let Gag = {

  init(socket, element){ if(!element){ return }
    let slug = element.getAttribute("data-slug")
    socket.connect()
    this.onReady(slug, socket)
  },

  onReady(slug, socket){
    let msgContainer = document.getElementById("msg-container")
    let msgInput     = document.getElementById("msg-input")
    let postButton   = document.getElementById("msg-submit")
    let gagChannel   = socket.channel("gag:" + slug)

    postButton.addEventListener("click", e => {
      let payload = {body: msgInput.value}
      gagChannel.push("new_comment", payload)
                .receive("error", e => console.log(e))
      msgInput.value = ""
    })

    gagChannel.on("new_comment", (resp) => {
      console.log(resp)
      // vidChannel.params.last_seen_id = resp.id
      // this.renderAnnotation(msgContainer, resp)
    })

    // msgContainer.addEventListener("click", e => {
    //   e.preventDefault()
    //   let seconds = e.target.getAttribute("data-seek") ||
    //                 e.target.parentNode.getAttribute("data-seek")
    //   if (!seconds) { return }

    //   Player.seekTo(seconds)
    // })

    gagChannel.join()
      .receive("ok", resp => console.log("joined the video channel", resp) )
      .receive("error", reason => console.log("join failed", reason) )
      // .receive("ok", (resp) => {
      //   let ids = resp.annotations.map(ann => ann.id)
      //   if (ids.length > 0) {
      //     vidChannel.params.last_seen_id = Math.max(...ids)
      //   }
      //   this.scheduleMessages(msgContainer, resp.annotations)
      // })
      // .receive("error", reason => console.log("join failed", reason) )
  },

  // esc(str) {
  //   let div = document.createElement("div")
  //   div.appendChild(document.createTextNode(str))
  //   return div.innerHTML
  // },

  // renderAnnotation(msgContainer, {user, body, at}) {
  //   let template = document.createElement("div")

  //   template.innerHTML = `
  //   <a href="#" data-seek="${this.esc(at)}">
  //     [${this.formatTime(at)}]
  //     <b>${this.esc(user.username)}</b>: ${this.esc(body)}
  //   </a>
  //   `
  //   msgContainer.appendChild(template)
  //   msgContainer.scrollTop = msgContainer.scrollHeight
  // },

  // scheduleMessages(msgContainer, annotations) {
  //   setTimeout(() => {
  //     let ctime = Player.getCurrentTime()
  //     let remaining = this.renderAtTime(annotations, ctime, msgContainer)
  //     this.scheduleMessages(msgContainer, remaining)
  //   }, 1000)
  // },

  // renderAtTime(annotations, seconds, msgContainer) {
  //   return annotations.filter( ann => {
  //     if(ann.at > seconds) {
  //       return true
  //     } else {
  //       this.renderAnnotation(msgContainer, ann)
  //       return false
  //     }
  //   })
  // },

  // formatTime(at) {
  //   let date = new Date(null)
  //   date.setSeconds(at / 1000)
  //   return date.toISOString().substr(14, 5)
  // }
}
export default Gag
