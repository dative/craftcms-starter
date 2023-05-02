/** @type {import('tailwindcss').Config} */
module.exports = {
  presets: [require('./tailwind.preset.cjs')],
  content: ['./cms/config/redactor/**/*.json'],
  corePlugins: {
    preflight: true,
  },
  important: true,
  safelist: ['rtf-left', 'rtf-right', 'rtf-center'],
  plugins: [require('@tailwindcss/typography')],
};
