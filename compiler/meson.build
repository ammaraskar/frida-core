compiler_sources = [
  'compiler.vala',
]

raw_compiler = executable('frida-compiler-raw', compiler_sources,
  vala_args: [core_vala_args, tls_provider_vala_args, '--pkg=posix'],
  link_args: executable_no_exports_link_args,
  link_depends: executable_no_exports_link_depends,
  dependencies: [core_dep] + extra_deps,
)

custom_target('frida-compiler',
  input: [raw_compiler, 'frida-compiler.xcent'],
  output: 'frida-compiler' + exe_suffix,
  command: post_process + ['executable', 're.frida.CompilerCommand', '@INPUT1@'],
  install: true,
  install_dir: get_option('bindir'),
)
