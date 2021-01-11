// SPDX-License-Identifier: MIT
// Copyright © 2021 makadaw

import Foundation
import PathKit
import Stencil

class Renderer {
    let template: Environment
    let templatePath: String?

    init(templatePath: String? = nil) {
        self.templatePath = templatePath
        self.template = Environment()
    }

    func render(targets: Any) throws -> String {
        let content: String = try {
            if let templatePath = templatePath {
                let path = PathKit.Path(templatePath)
                return try path.read()
            } else {
                return Self.defaultTmpl
            }
        }()
        return try self.template.renderTemplate(string: content, context: ["targets": targets])
    }

    static let defaultTmpl =
    """
    # Generated BUCK file from SPM configuration

    {% for target in targets %}
    apple_library(
      name = '{{ target.name }}',
      srcs = ['{{ target.srcs|join:"', '" }}'],
      {% if target.exportedHeaders %}exported_headers = glob(['{{ target.exportedHeaders }}']),{% endif %}
      {% if target.deps %}deps = [{% for dep in target.deps %}'//Packages:{{ dep }}',{% endfor %}],{% endif %}
      {% if target.preprocessorFlags %}preprocessor_flags = ['-fobjc-arc', '{{ target.preprocessorFlags|join:"', '" }}'],{% endif %}
      {% if target.preprocessorFlags %}exported_preprocessor_flags = ['{{ target.preprocessorFlags|join:"', '" }}'],{% endif %}
      modular = True,
      visibility = [ 'PUBLIC' ],
    )
    {% endfor %}
    """
}
