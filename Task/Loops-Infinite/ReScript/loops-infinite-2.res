let rec inf_loop = () => {
  Js.log("SPAM")
  inf_loop()
}
