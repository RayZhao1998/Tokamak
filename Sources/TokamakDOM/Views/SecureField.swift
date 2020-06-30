// Copyright 2020 Tokamak contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//  Created by Jed Fox on 06/28/2020.
//

import TokamakCore

public typealias SecureField = TokamakCore.SecureField

extension SecureField: ViewDeferredToRenderer where Label == Text {
  public var deferredBody: AnyView {
    AnyView(HTML("input", [
      "type": "password",
      "value": textBinding.wrappedValue,
      "placeholder": _SecureFieldProxy(self).label.content,
    ], listeners: [
      "keypress": { event in if event.key == "Enter" { commitAction() } },
      "input": { event in
          if let newValue = event.target.object?.value.string {
            textBinding.wrappedValue = newValue
          }
        },
    ]))
  }
}
