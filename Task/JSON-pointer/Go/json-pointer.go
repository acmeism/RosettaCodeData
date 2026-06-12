package main

import (
   "encoding/json"
   "fmt"
   "log"
   "os"
   "regexp"
   "strconv"
   "strings"
)

var reIndex = regexp.MustCompile(`^(0|[1-9][0-9]*)$`)

type JSONPointer []string

func NewJSONPointer(pointer string) (*JSONPointer, error) {
   var tokens JSONPointer

   if pointer == "" {
      return &tokens, nil
   }

   p, slash := strings.CutPrefix(pointer, "/")
   if !slash && len(p) > 0 {
      return nil, fmt.Errorf(
         "\"%s\" pointers must start with a slash or be the empty string", pointer)
   }

   for _, token := range strings.Split(p, "/") {
      tokens = append(tokens,
         strings.ReplaceAll(strings.ReplaceAll(token, "~1", "/"), "~0", "~"),
      )
   }
   return &tokens, nil
}

func (p JSONPointer) Resolve(data interface{}) (interface{}, error) {
   obj := data
   var found bool
   for i, token := range p {
      obj, found = getItem(obj, token)
      if !found {
         return nil, fmt.Errorf("\"%s\" does not exist", encode(p[:i+1]))
      }
   }
   return obj, nil
}

func (p JSONPointer) String() string {
   return encode(p)
}

func encode(tokens []string) string {
   var encoded []string
   for _, token := range tokens {
      encoded = append(encoded,
         strings.ReplaceAll(strings.ReplaceAll(token, "~", "~0"), "/", "~1"))
   }
   if len(encoded) == 0 {
      return ""
   }
   return "/" + strings.Join(encoded, "/")
}

func getItem(data interface{}, token string) (interface{}, bool) {
   switch data.(type) {
   case []interface{}:
      return getArrayItem(data.([]interface{}), token)
   case map[string]interface{}:
      return getObjectItem(data.(map[string]interface{}), token)
   default:
      return nil, false
   }
}

func getArrayItem(array []interface{}, token string) (interface{}, bool) {
   if reIndex.MatchString(token) {
      if idx, err := strconv.Atoi(token); err == nil && idx < len(array) {
         return array[idx], true
      }
   }
   return nil, false
}

func getObjectItem(object map[string]interface{}, token string) (interface{}, bool) {
   if val, found := object[token]; found {
      return val, true
   }
   return nil, false
}

func prettyJSON(data interface{}) string {
   b, err := json.MarshalIndent(data, "", "  ")
   if err != nil {
      log.Fatal(err)
   }
   return string(b)
}

func loadJSON(f string) interface{} {
   bytes, err := os.ReadFile(f)
   if err != nil {
      log.Fatal(err)
   }

   var obj interface{}
   err = json.Unmarshal(bytes, &obj)
   if err != nil {
      log.Fatal(err)
   }

   return obj
}

var examples = []string{
   "",
   "/",
   "/ ",
   "/abc",
   "/def/",
   "/g~1h",
   "/i~0j",
   "/wiki/links/0",
   "/wiki/links/1",
   "/wiki/links/2",
   "/wiki/name",
   "/no/such/thing",
   "bad/pointer",
}

func main() {
   doc := loadJSON("example.json")
   for _, s := range examples {
      p, err := NewJSONPointer(s)
      if err != nil {
         fmt.Printf("error: %v\n\n", err)
         continue
      }

      if result, err := p.Resolve(doc); err != nil {
         fmt.Printf("error: %v\n\n", err)
      } else {
         fmt.Printf("\"%s\" -> %s\n\n", p, prettyJSON(result))
      }
   }

}
