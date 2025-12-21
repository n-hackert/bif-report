// helpers for writing
// TODO: remove
// a little reminder to add references...
#let mr = {
  highlight()[
    MISSING REF
  ]
}

// make refs to panels clickable
#let panel_ref(fig_label, panel) = {
  // call with suffix like ".A"
  link(fig_label)[#ref(fig_label)#panel]
}

// fun little experiment but pretty useless
// can be rendered as follows
// #context todo_state.final()
#let todo_state = state("todos", [])
#let todo(content) = {
  todo_state.update(it => it + content + [

    
  ])
  highlight()[
    TODO: #content
  ]
}