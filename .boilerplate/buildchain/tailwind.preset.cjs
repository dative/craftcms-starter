/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    extend: {
      typography: (theme) => ({
        DEFAULT: {
          css: {
            a: {
              color: theme('colors.purple.700'),
              textDecoration: 'none',
              '&:hover': {
                textDecoration: 'underline'
              }
            },
            h2: {},
            h3: {},
            h4: {},
            h5: {},
            h6: {},
            ul: {},
            ol: {},
            li: {}
          }
        }
      }),
      dropShadow: {
        nav: '0px 5px 36px rgba(0, 0, 0, 0.05)',
        accordion: '0px 4px 16px rgba(0, 0, 0, 0.05)',
        form: '0px 10px 24px rgba(0, 0, 0, 0.03)',
        profile: '0px 4px 30px rgba(0, 0, 0, 0.05)',
        quote: '0px 4px 48px rgba(0, 0, 0, 0.05)',
        program: '0px 4px 24px rgba(0, 0, 0, 0.05)'
      }
    }
  },
  plugins: [require('@tailwindcss/typography'), require('@tailwindcss/forms')]
}
