import Link from 'next/link'

export default function Home() {
  return (
    <main className="min-h-screen">
      {/* Hero Section */}
      <section className="bg-gradient-to-br from-primary to-accent text-white">
        <nav className="container mx-auto px-6 py-4">
          <div className="flex justify-between items-center">
            <h1 className="text-2xl font-bold">KonbitWorks</h1>
            <div className="space-x-4">
              <a href="#features" className="hover:underline">Features</a>
              <a href="#how-it-works" className="hover:underline">How It Works</a>
              <a href="#download" className="bg-white text-primary px-6 py-2 rounded-lg font-semibold hover:bg-gray-100 transition">
                Download App
              </a>
            </div>
          </div>
        </nav>

        <div className="container mx-auto px-6 py-24 md:py-32">
          <div className="max-w-3xl">
            <h2 className="text-5xl md:text-6xl font-bold mb-6">
              Travay Gig pou Ayisyen
            </h2>
            <p className="text-xl md:text-2xl mb-8 text-gray-100">
              Connect with your community. Find local gigs. Offer your services.
              Build together.
            </p>
            <p className="text-lg mb-8 text-gray-200">
              KonbitWorks is a marketplace designed for the Haitian community
              to find and post local jobs, services, and gig work.
            </p>
            <div className="flex flex-wrap gap-4">
              <a href="#download" className="bg-white text-primary px-8 py-4 rounded-lg text-lg font-semibold hover:bg-gray-100 transition shadow-lg">
                Get Started
              </a>
              <a href="#how-it-works" className="bg-transparent border-2 border-white text-white px-8 py-4 rounded-lg text-lg font-semibold hover:bg-white hover:text-primary transition">
                Learn More
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-20 bg-gray-50">
        <div className="container mx-auto px-6">
          <h2 className="text-4xl font-bold text-center mb-4">Why KonbitWorks?</h2>
          <p className="text-center text-gray-600 mb-12 max-w-2xl mx-auto">
            Everything you need to find work or hire help in your community
          </p>

          <div className="grid md:grid-cols-3 gap-8">
            {/* Feature 1 */}
            <div className="bg-white p-8 rounded-xl shadow-lg hover:shadow-xl transition">
              <div className="w-16 h-16 bg-primary rounded-lg flex items-center justify-center mb-4">
                <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
              </div>
              <h3 className="text-xl font-bold mb-2">Local Focus</h3>
              <p className="text-gray-600">
                Find gigs and services near you with our map-based interface.
                Support your local community.
              </p>
            </div>

            {/* Feature 2 */}
            <div className="bg-white p-8 rounded-xl shadow-lg hover:shadow-xl transition">
              <div className="w-16 h-16 bg-secondary rounded-lg flex items-center justify-center mb-4">
                <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <h3 className="text-xl font-bold mb-2">Fair Pricing</h3>
              <p className="text-gray-600">
                Set your own rates in Haitian Gourdes (HTG).
                Transparent pricing for both workers and clients.
              </p>
            </div>

            {/* Feature 3 */}
            <div className="bg-white p-8 rounded-xl shadow-lg hover:shadow-xl transition">
              <div className="w-16 h-16 bg-accent rounded-lg flex items-center justify-center mb-4">
                <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
              </div>
              <h3 className="text-xl font-bold mb-2">Community First</h3>
              <p className="text-gray-600">
                Built for the Haitian community, with support for Kreyòl.
                Connect with neighbors and build trust.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* How It Works Section */}
      <section id="how-it-works" className="py-20 bg-white">
        <div className="container mx-auto px-6">
          <h2 className="text-4xl font-bold text-center mb-12">Kouman li fonksyone</h2>

          <div className="max-w-4xl mx-auto space-y-12">
            {/* Step 1 */}
            <div className="flex flex-col md:flex-row items-center gap-8">
              <div className="flex-shrink-0 w-16 h-16 bg-primary text-white rounded-full flex items-center justify-center text-2xl font-bold">
                1
              </div>
              <div>
                <h3 className="text-2xl font-bold mb-2">Create an Account</h3>
                <p className="text-gray-600 text-lg">
                  Sign up with your email and create your profile. It's quick and free!
                </p>
              </div>
            </div>

            {/* Step 2 */}
            <div className="flex flex-col md:flex-row items-center gap-8">
              <div className="flex-shrink-0 w-16 h-16 bg-primary text-white rounded-full flex items-center justify-center text-2xl font-bold">
                2
              </div>
              <div>
                <h3 className="text-2xl font-bold mb-2">Browse or Post Gigs</h3>
                <p className="text-gray-600 text-lg">
                  Looking for work? Browse available gigs on the map.
                  Need help? Post your own gig with details and pricing.
                </p>
              </div>
            </div>

            {/* Step 3 */}
            <div className="flex flex-col md:flex-row items-center gap-8">
              <div className="flex-shrink-0 w-16 h-16 bg-primary text-white rounded-full flex items-center justify-center text-2xl font-bold">
                3
              </div>
              <div>
                <h3 className="text-2xl font-bold mb-2">Connect & Work</h3>
                <p className="text-gray-600 text-lg">
                  Connect with others in your community, agree on terms, and get to work!
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section id="download" className="py-20 bg-gradient-to-br from-primary to-accent text-white">
        <div className="container mx-auto px-6 text-center">
          <h2 className="text-4xl font-bold mb-6">Ready to Get Started?</h2>
          <p className="text-xl mb-8 max-w-2xl mx-auto">
            Download KonbitWorks today and start connecting with your community
          </p>

          <div className="flex flex-wrap justify-center gap-4">
            <a href="#" className="bg-white text-primary px-8 py-4 rounded-lg text-lg font-semibold hover:bg-gray-100 transition inline-flex items-center gap-2">
              <svg className="w-6 h-6" viewBox="0 0 24 24" fill="currentColor">
                <path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09l.01-.01zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z"/>
              </svg>
              App Store
            </a>
            <a href="#" className="bg-white text-primary px-8 py-4 rounded-lg text-lg font-semibold hover:bg-gray-100 transition inline-flex items-center gap-2">
              <svg className="w-6 h-6" viewBox="0 0 24 24" fill="currentColor">
                <path d="M3,20.5V3.5C3,2.91 3.34,2.39 3.84,2.15L13.69,12L3.84,21.85C3.34,21.6 3,21.09 3,20.5M16.81,15.12L6.05,21.34L14.54,12.85L16.81,15.12M20.16,10.81C20.5,11.08 20.75,11.5 20.75,12C20.75,12.5 20.53,12.9 20.18,13.18L17.89,14.5L15.39,12L17.89,9.5L20.16,10.81M6.05,2.66L16.81,8.88L14.54,11.15L6.05,2.66Z"/>
              </svg>
              Google Play
            </a>
          </div>

          <p className="mt-8 text-sm text-gray-200">
            Available soon on iOS, Android, and Web
          </p>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-12">
        <div className="container mx-auto px-6">
          <div className="grid md:grid-cols-3 gap-8">
            <div>
              <h3 className="text-xl font-bold mb-4">KonbitWorks</h3>
              <p className="text-gray-400">
                Building stronger communities through local work opportunities.
              </p>
            </div>
            <div>
              <h4 className="font-bold mb-4">Links</h4>
              <ul className="space-y-2 text-gray-400">
                <li><a href="#features" className="hover:text-white">Features</a></li>
                <li><a href="#how-it-works" className="hover:text-white">How It Works</a></li>
                <li><a href="#" className="hover:text-white">Privacy Policy</a></li>
                <li><a href="#" className="hover:text-white">Terms of Service</a></li>
              </ul>
            </div>
            <div>
              <h4 className="font-bold mb-4">Contact</h4>
              <ul className="space-y-2 text-gray-400">
                <li>Email: info@konbitworks.com</li>
                <li>Support: support@konbitworks.com</li>
              </ul>
            </div>
          </div>

          <div className="border-t border-gray-800 mt-8 pt-8 text-center text-gray-400">
            <p>&copy; 2024 KonbitWorks. All rights reserved.</p>
          </div>
        </div>
      </footer>
    </main>
  )
}
