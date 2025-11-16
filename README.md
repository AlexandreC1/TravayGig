# TravayGig

A platform for gig work and freelance opportunities.

## Supabase Configuration

This project uses Supabase as the backend service for authentication, database, and storage.

### Setup Instructions

1. **Environment Variables**

   Copy the `.env.example` file to `.env.local`:
   ```bash
   cp .env.example .env.local
   ```

   The `.env.local` file has already been configured with the Supabase credentials.

2. **Supabase Project Details**

   - **Project URL**: https://audgbcajapzldmcfpmmp.supabase.co
   - **Project Reference**: audgbcajapzldmcfpmmp

3. **Environment Variables**

   The following environment variables are configured:

   - `NEXT_PUBLIC_SUPABASE_URL`: Your Supabase project URL
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`: Your Supabase anonymous/public API key

### Security Notes

- The `.env.local` file contains sensitive credentials and is gitignored
- Never commit the `.env.local` file to version control
- The `.env.example` file serves as a template for other developers

### Next Steps

1. Install dependencies (once package.json is added)
2. Set up Supabase database schema
3. Configure authentication providers
4. Build your application features

## Development

More development instructions will be added as the project grows.

## License

TBD
