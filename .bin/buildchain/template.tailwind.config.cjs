/** @type {import('tailwindcss').Config} */
module.exports = {
  presets: [require('./tailwind.preset.cjs')],
  content: [
    './cms/templates/**/*.{twig,html}',
    './cms/config/redactor/**/*.json',
    './src/js/**/*.{js,ts}',
  ],
  safelist: ['rtf-left', 'rtf-right', 'rtf-center'],
  plugins: [require('@tailwindcss/typography'), require('@tailwindcss/forms')],
};
