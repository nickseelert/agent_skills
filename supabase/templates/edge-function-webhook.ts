// Webhook Handler Edge Function Template
// Save to: supabase/functions/<function-name>/index.ts

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// Verify webhook signature (example for Stripe)
async function verifySignature(
  payload: string,
  signature: string,
  secret: string
): Promise<boolean> {
  const encoder = new TextEncoder()
  const key = await crypto.subtle.importKey(
    "raw",
    encoder.encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"]
  )
  const signatureBuffer = await crypto.subtle.sign(
    "HMAC",
    key,
    encoder.encode(payload)
  )
  const signatureHex = Array.from(new Uint8Array(signatureBuffer))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("")
  
  return signature === signatureHex
}

serve(async (req) => {
  try {
    // Get raw body for signature verification
    const body = await req.text()
    const signature = req.headers.get('x-webhook-signature') || ''
    const webhookSecret = Deno.env.get('WEBHOOK_SECRET') || ''

    // Verify the webhook signature
    // const isValid = await verifySignature(body, signature, webhookSecret)
    // if (!isValid) {
    //   return new Response(
    //     JSON.stringify({ error: 'Invalid signature' }),
    //     { status: 401 }
    //   )
    // }

    const payload = JSON.parse(body)
    console.log('Webhook received:', payload.type || 'unknown')

    // Create Supabase client
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
    )

    // Handle different webhook events
    switch (payload.type) {
      case 'user.created':
        // Handle user creation
        const { error } = await supabase
          .from('webhook_logs')
          .insert({ 
            event_type: payload.type,
            payload: payload,
            processed_at: new Date().toISOString()
          })
        if (error) console.error('Error logging webhook:', error)
        break

      case 'payment.completed':
        // Handle payment
        break

      default:
        console.log('Unhandled webhook type:', payload.type)
    }

    return new Response(
      JSON.stringify({ received: true }),
      { 
        headers: { 'Content-Type': 'application/json' },
        status: 200 
      },
    )
  } catch (error) {
    console.error('Webhook error:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { 
        headers: { 'Content-Type': 'application/json' },
        status: 500 
      },
    )
  }
})
