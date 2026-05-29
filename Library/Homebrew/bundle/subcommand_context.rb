# typed: strict
# frozen_string_literal: true

require "bundle/extensions/extension"
require "abstract_command"

module Homebrew
  module Cmd
    class Bundle < Homebrew::AbstractCommand
      class SubcommandContext < T::Struct
        const :subcommand, String
        const :global, T::Boolean
        const :file, T.nilable(String)
        const :no_upgrade, T::Boolean
        const :verbose, T::Boolean
        const :force, T::Boolean
        const :ask, T::Boolean
        const :jobs, Integer
        const :zap, T::Boolean
        const :no_type_args, T::Boolean
        const :extensions, T::Array[T.class_of(Homebrew::Bundle::Extension)]

        sig { params(args: T.untyped, extension: T.class_of(Homebrew::Bundle::Extension)).returns(T::Boolean) }
        def extension_selected?(args, extension)
          args.public_send(extension.predicate_method)
        end

        sig { params(args: T.untyped, extension: T.class_of(Homebrew::Bundle::Extension)).returns(T::Boolean) }
        def extension_dump_disabled?(args, extension)
          args.public_send(extension.dump_disable_predicate_method)
        end

        sig { params(args: T.untyped).returns(T::Array[Symbol]) }
        def selected_types(args)
          # We intentionally omit the s from `brews`, `casks`, and `taps` for ease of handling later.
          type_hash = {
            brew: args.formulae?,
            cask: args.casks?,
            tap:  args.taps?,
          }
          extensions.each do |extension|
            type_hash[extension.type] = extension_selected?(args, extension)
          end
          type_hash[:none] = no_type_args
          type_hash.select { |_, v| v }.keys
        end
      end
    end
  end
end
