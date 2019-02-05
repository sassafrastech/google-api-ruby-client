# Copyright 2010 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


module Google
  class APIClient
    module ENV
      OS_VERSION = begin
        if RUBY_PLATFORM =~ /mswin|win32|mingw|bccwin|cygwin/
          # TODO(bobaman)
          # Confirm that all of these Windows environments actually have access
          # to the `ver` command.
          `ver`.sub(/\s*\[Version\s*/, '/').sub(']', '').strip
        elsif RUBY_PLATFORM =~ /darwin/i
          "Mac OS X/#{`sw_vers -productVersion`}"
        elsif RUBY_PLATFORM == 'java'
          # Get the information from java system properties to avoid spawning a
          # sub-process, which is not friendly in some contexts (web servers).
          require 'java'
          name = java.lang.System.getProperty('os.name')
          version = java.lang.System.getProperty('os.version')
          "#{name}/#{version}"
        else
          `uname -sr`.sub(' ', '/')
          # Added 'strip' to match 2018 update https://github.com/googleapis/google-api-ruby-client/pull/654
          # This is to fix error "ArgumentError: header User-Agent has field value "Hollaback Fusion Tables/1.0.0 google-api-ruby-client/0.8.2 Mac OS X/10.14.2\n (gzip)", this cannot include CR/LF"
          # Error was coming from ruby in line 43 of FusionTablesHelper in Hollaback Backend: @api_method ||= client.discovered_api('fusiontables', 'v2').query.sql
          # Decided to fork instead of upgrade because we have to replace fusion tables within a year.
        end.strip
      rescue Exception
        RUBY_PLATFORM
      end
    end
  end
end
