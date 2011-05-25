load 'bin/rubyc'

archs = ARGV.shift.split(' ')
ARGV.each do |path|
  out = File.join(File.dirname(path), File.basename(path, '.rb') + '.rbo');

  if !File.exist?(out) or
      File.mtime(path) > File.mtime(out) or
      File.mtime('./miniruby') > File.mtime(out)

    puts "Compiling #{out}"
    MacRuby::Compiler.compile_file(path, internal: true, archs: archs)
  end
end
