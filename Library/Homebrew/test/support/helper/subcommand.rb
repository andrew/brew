# typed: false
# frozen_string_literal: true

module Test
  module Helper
    module Subcommand
      class Args
        attr_reader :named

        KNOWN_PREDICATES = [
          :all?,
          :cargo?,
          :casks?,
          :check?,
          :cleanup?,
          :describe?,
          :flatpak?,
          :force?,
          :formulae?,
          :global?,
          :go?,
          :install?,
          :krew?,
          :mas?,
          :no_cargo?,
          :no_flatpak?,
          :no_go?,
          :no_krew?,
          :no_npm?,
          :no_restart?,
          :no_secrets?,
          :no_upgrade?,
          :no_uv?,
          :no_vscode?,
          :no_winget?,
          :npm?,
          :quiet?,
          :services?,
          :taps?,
          :upgrade?,
          :uv?,
          :verbose?,
          :vscode?,
          :winget?,
          :zap?,
        ].freeze

        def initialize(named:, **options)
          @named = named
          @options = options
        end

        def method_missing(name, *args)
          if args.empty? && @options.key?(name)
            @options.fetch(name)
          elsif args.empty? && KNOWN_PREDICATES.include?(name)
            false
          else
            super
          end
        end

        def respond_to_missing?(name, include_private = false)
          @options.key?(name) || KNOWN_PREDICATES.include?(name) || super
        end
      end

      def args_for_subcommand(subcommand = nil, *named, **options)
        Test::Helper::Subcommand::Args.new(named:, subcommand: subcommand&.to_s, **options)
      end

      def bundle_subcommand_context(subcommand, global: false, file: nil, no_upgrade: false, verbose: false,
                                    force: false, ask: false, jobs: 1, zap: false, no_type_args: true)
        require "cmd/bundle"

        Homebrew::Cmd::Bundle::SubcommandContext.new(
          subcommand:   subcommand.to_s,
          global:,
          file:,
          no_upgrade:,
          verbose:,
          force:,
          ask:,
          jobs:,
          zap:,
          no_type_args:,
          extensions:   Homebrew::Bundle.extensions,
        )
      end
    end
  end
end
