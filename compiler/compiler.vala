namespace Frida.CompilerCommand {

	private static bool output_version = false;

	const OptionEntry[] options = {
		{ "version", 0, 0, OptionArg.NONE, ref output_version, "Output version information and exit", null },
		{ null }
	};

	private static async int main (string[] args) {
		try {
			var ctx = new OptionContext ();
			ctx.set_help_enabled (true);
			ctx.add_main_entries (options, null);
			ctx.parse (ref args);
		} catch (OptionError e) {
			printerr ("%s\n", e.message);
			printerr ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
			return 1;
		}

		if (output_version) {
			stdout.printf ("%s\n", version_string ());
			return 0;
		}

		if (args.length < 2) {
			printerr ("Need to pass a file to compile\n");
			return 1;
		}

		Compiler compiler = new Compiler();

		BuildOptions build_options = new BuildOptions();
		build_options.project_root = Environment.get_current_dir();

		compiler.diagnostics.connect (diagnostic => {
			// Text is last variant entry.
			string text = diagnostic.get_child_value(diagnostic.n_children() - 1).get_string();
			printerr("%s\n", text);
		});
		try {
			string output = yield compiler.build(args[1], build_options);
			stdout.puts(output);
		} catch (GLib.Error e) {
			printerr("GlibError: %s\n", e.message);
			return 1;
		}

		return 0;
	}

}
